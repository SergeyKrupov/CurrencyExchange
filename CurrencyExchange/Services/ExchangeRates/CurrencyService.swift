//
//  ExchangeRatesService.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Moya
import RxSwift

protocol CurrencyService {

    func observeRate(first: Currency, second: Currency) -> Observable<Rate>
}

final class CurrencyServiceImpl: CurrencyService {

    init(ratesProvider: MoyaProvider<ExchangeRateAPI>, timeInterval: RxTimeInterval) {
        self.ratesProvider = ratesProvider
        self.timeInterval = timeInterval

        rates = makeSharedRatesObservable()
    }

    // MARK: - CurrencyService
    func observeRate(first: Currency, second: Currency) -> Observable<Rate> {
        return rates.flatMap { rates -> Observable<Rate> in
            let rate = rates.first { $0.first == first && $0.second == second }
            return Observable.from(optional: rate)
        }
    }

    // MARK: - Private
    private let ratesProvider: MoyaProvider<ExchangeRateAPI>
    private let timeInterval: RxTimeInterval
    private var rates: Observable<[Rate]>!

    private func obtainRates() -> Single<RatesResponse> {
        return Single<RatesResponse>.create { action -> Disposable in
            let cancellable = self.ratesProvider.request(.latest(base: .eur, symbols: Currency.allCases)) { result in
                switch result {
                case let .success(response):
                    do {
                        let ratesResponse = try response.map(RatesResponse.self, atKeyPath: nil, using: JSONDecoder(), failsOnEmptyData: true)
                        action(.success(ratesResponse))
                    } catch {
                        action(.error(error))
                    }
                case let .failure(error):
                    action(.error(error))
                }
            }
            return Disposables.create(with: cancellable.cancel)
        }
    }

    private func makeSharedRatesObservable() -> Observable<[Rate]> {
        return Observable<Int>
            .timer(timeInterval, period: timeInterval, scheduler: SerialDispatchQueueScheduler(qos: .default))
            .startWith(0)
            .flatMap { [obtainRates = self.obtainRates()] _ in
                obtainRates.asMaybe()
                    .catchError { _ in .empty() }
            }
            .map { response -> [Rate] in
                guard let first = Currency(rawValue: response.base) else {
                    return []
                }
                return response.rates.flatMap { tuple -> [Rate] in
                    guard let second = Currency(rawValue: tuple.key) else {
                        return []
                    }
                    let rate = Rate(first: first, second: second, rate: tuple.value)
                    return [rate, rate.inverted]
                }
            }
            .share(replay: 1, scope: .whileConnected)
    }
}
