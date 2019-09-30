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
    var amount: Double { get }
    var balance: Observable<Double> { get }

    var isAmountCorrect: Observable<Bool> { get }

    var amountTextBinder: Binder<String> { get }
    var amountValueBinder: Binder<Double> { get }

    func observeAmount(isChangedByUser: Bool) -> Observable<Double>
}

final class CurrencyCardInteractor: CurrencyCardInteractorProtocol {

    internal init(currency: Currency, profileService: ProfileService) {
        self.currency = currency
        self.profileService = profileService
    }

    // MARK: - CurrencyCardInteractorProtocol
    let currency: Currency

    var amount: Double {
        return amountRelay.value.value
    }

    var balance: Observable<Double> {
        return profileService.observeBalance(for: currency)
    }

    var isAmountCorrect: Observable<Bool> {
        return isAmountCorrectRelay.asObservable()
    }

    var amountTextBinder: Binder<String> {
        return Binder(self) { this, text in
            if let value = Double(text) {
                this.isAmountCorrectRelay.accept(true)
                this.amountRelay.accept(Amount(value: value, updatedByUser: true))
            } else {
                this.isAmountCorrectRelay.accept(false)
            }
        }
    }

    var amountValueBinder: Binder<Double> {
        return Binder(self) { this, value in
            this.isAmountCorrectRelay.accept(true)
            this.amountRelay.accept(Amount(value: value, updatedByUser: false))
        }
    }

    func observeAmount(isChangedByUser: Bool) -> Observable<Double> {
        return amountRelay
            .filter { $0.updatedByUser == isChangedByUser }
            .map { $0.value }
    }

    // MARK: - Private
    private struct Amount {
        let value: Double
        let updatedByUser: Bool
    }

    private let profileService: ProfileService
    private let amountRelay = BehaviorRelay(value: Amount(value: 0, updatedByUser: false))
    private let isAmountCorrectRelay = BehaviorRelay(value: true)
}
