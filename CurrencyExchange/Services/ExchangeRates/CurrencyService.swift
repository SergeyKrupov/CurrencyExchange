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
            assert(rate != nil)
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
            .map(prepareRates)
            .do(onNext: { rates in
                // Чтобы убедиться в том, что курсы обновляются
                #if false
                debugPrint("Обновление курсов:")
                for rate in rates {
                    debugPrint(rate.toString())
                }
                debugPrint("-----------------")
                #endif
            })
            .share(replay: 1, scope: .whileConnected)
    }
}

private func prepareRates(from response: RatesResponse) -> [Rate] {
    var pairs = response.rates.compactMap { tuple -> (currency: Currency, rate: Double)? in
        Currency(rawValue: tuple.key).flatMap { (currency: $0, rate: tuple.value) }
    }

    if let currency = Currency(rawValue: response.base) {
        pairs.append((currency: currency, rate: 1))
    }

    return pairs.reduce([]) { rates, first -> [Rate] in
        pairs.reduce(rates) { rates, second -> [Rate] in
            let rate = Rate(first: first.currency, second: second.currency, rate: second.rate / first.rate)
            return rates + [rate, rate.inverted]
        }
    }
}
