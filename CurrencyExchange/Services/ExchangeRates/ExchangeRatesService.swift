//
//  ExchangeRatesService.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Moya
import RxSwift

protocol ExchangeRatesService {

    func observeRate(base: Currency) -> Observable<[Currency: Double]>
}

final class ExchangeRatesServiceImpl: ExchangeRatesService {

    init(ratesProvider: MoyaProvider<ExchangeRateAPI>,
         timeInterval: RxTimeInterval) {
        self.ratesProvider = ratesProvider
        self.timeInterval = timeInterval
    }

    // MARK: - ExchangeRatesService
    func observeRate(base: Currency) -> Observable<[Currency: Double]> {
        let single = Single<[Currency: Double]>.create { action -> Disposable in
            let cancellable = self.ratesProvider.request(.latest(base: base, symbols: Currency.allCases)) { result in
                switch result {
                case let .success(response):
                    do {
                        let ratesResponse = try response.map(RatesResponse.self, atKeyPath: nil, using: JSONDecoder(), failsOnEmptyData: true)
                        guard Currency(rawValue: ratesResponse.base) == base else {
                            throw RatesError.malformedResponse
                        }
                        let pairs = ratesResponse.rates.compactMap { tuple in
                            Currency(rawValue: tuple.key).flatMap { ($0, tuple.value) }
                        }
                        action(.success(Dictionary(uniqueKeysWithValues: pairs)))
                    } catch {
                        action(.error(error))
                    }
                case let .failure(error):
                    action(.error(error))
                }
            }
            return Disposables.create(with: cancellable.cancel)
        }

        return Observable<Int>
            .timer(timeInterval, period: timeInterval, scheduler: SerialDispatchQueueScheduler(qos: .default))
            .startWith(0)
            .flatMapFirst { _ in single.asObservable() }
    }

    // MARK: - Private
    private let ratesProvider: MoyaProvider<ExchangeRateAPI>
    private let timeInterval: RxTimeInterval
}
