//
//  CurrencyCardCurrencyCardPresenter.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CurrencyCardPresenterProtocol {

    func setupBindings(_ view: CurrencyCardViewProtocol)
}

final class CurrencyCardPresenter: CurrencyCardInterface {

    init(interactor: CurrencyCardInteractorProtocol,
         router: CurrencyCardRouterProtocol,
         view: CurrencyCardViewProtocol) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }

    // MARK: - CurrencyCardModuleInput
    var currency: Currency {
        return interactor.currency
    }

    var amount: Double {
        return interactor.amount
    }

    var rateBinder: Binder<Rate> {
        return Binder(rateRelay) { relay, value in
            relay.accept(value)
        }
    }

    var amountBinder: Binder<Double> {
        return interactor.amountValueBinder
    }

    func observeAmount() -> Observable<Double> {
        return interactor.observeAmount(isChangedByUser: true)
    }

    // MARK: - Private
    private let interactor: CurrencyCardInteractorProtocol
    private let router: CurrencyCardRouterProtocol
    private weak var view: CurrencyCardViewProtocol?

    private let disposeBag = DisposeBag()
    private let rateRelay = BehaviorRelay<Rate?>(value: nil)
}

// MARK: - CurrencyCardPesenterProtocol
extension CurrencyCardPresenter: CurrencyCardPresenterProtocol {

    func setupBindings(_ view: CurrencyCardViewProtocol) {
        view.setCurrencyName(interactor.currency.rawValue)

        view.amountText
            .bind(to: interactor.amountTextBinder)
            .disposed(by: disposeBag)

        interactor.isAmountCorrect
            .bind(to: Binder(self) { this, value in
                let color: UIColor = value ? .black : .red
                this.view?.setAmountColor(color)
            })
            .disposed(by: disposeBag)

        interactor.balance
            .map { [currency] in String(format: "Balance: %@%0.2f", currency.symbol, $0) }
            .bind(to: view.balanceText)
            .disposed(by: disposeBag)

        rateRelay
            .flatMap { Observable.from(optional: $0?.toString()) }
            .bind(to: view.rateText)
            .disposed(by: disposeBag)

        rateRelay
            .map { $0 != nil }
            .bind(to: view.isActivityIndicatorHidden)
            .disposed(by: disposeBag)

        interactor.observeAmount(isChangedByUser: false)
            .map { String(format: "%0.2f", $0) }
            .bind(to: view.amountText)
            .disposed(by: disposeBag)
    }
}
