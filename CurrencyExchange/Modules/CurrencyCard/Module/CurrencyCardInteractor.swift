//
//  CurrencyCardCurrencyCardInteractor.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CurrencyCardInteractorProtocol: class {

    var currency: Currency { get }
    var balance: Observable<Double> { get }
    var amount: Observable<Double?> { get }

    var amountText: Binder<String> { get }
}

final class CurrencyCardInteractor: CurrencyCardInteractorProtocol {

    internal init(currency: Currency, profileService: ProfileService) {
        self.currency = currency
        self.profileService = profileService
    }

    // MARK: - CurrencyCardInteractorProtocol
    let currency: Currency

    var balance: Observable<Double> {
        return profileService.observeBalance(for: currency)
    }

    var amount: Observable<Double?> {
        return amountSubject
    }

    var amountText: Binder<String> {
        return Binder(self) { this, text in
            if let value = Double(text) {
                this.amountSubject.onNext(value)
            }
        }
    }

    // MARK: - Private
    private let profileService: ProfileService
    private let amountSubject = ReplaySubject<Double?>.create(bufferSize: 1)
}
