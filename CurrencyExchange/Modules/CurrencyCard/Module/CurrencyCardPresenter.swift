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

    var amount: AnyObserver<Double> {
        return AnyObserver(amountSubject)
    }

    var rate: AnyObserver<Rate> {
        return AnyObserver(rateSubject)
    }

    var output: Observable<CurrencyCardOutput> {
        return outputSubject.asObservable()
    }

    // MARK: - Private
    private let interactor: CurrencyCardInteractorProtocol
    private let router: CurrencyCardRouterProtocol
    private weak var view: CurrencyCardViewProtocol?

    private let disposeBag = DisposeBag()
    private let amountSubject = ReplaySubject<Double>.create(bufferSize: 1)
    private let rateSubject = ReplaySubject<Rate>.create(bufferSize: 1)
    private let outputSubject = PublishSubject<CurrencyCardOutput>()
}

// MARK: - CurrencyCardPesenterProtocol
extension CurrencyCardPresenter: CurrencyCardPresenterProtocol {

    func setupBindings(_ view: CurrencyCardViewProtocol) {
        view.setCurrencyName(interactor.currency.rawValue)

        view.amountText
            .bind(to: interactor.amountText)
            .disposed(by: disposeBag)

        interactor.amount
            .bind(to: Binder(self) { this, value in
                let color: UIColor = value == nil ? .red : .black
                this.view?.setAmountColor(color)
            })
            .disposed(by: disposeBag)

        interactor.amount
            .flatMap { Observable.from(optional: $0) }
            .map(CurrencyCardOutput.init)
            .bind(to: outputSubject)
            .disposed(by: disposeBag)

        interactor.balance
            .map { [currency] in String(format: "Balance: %@%0.2f", currency.symbol, $0) }
            .bind(to: view.balanceText)
            .disposed(by: disposeBag)

        rateSubject
            .map { $0.toString() }
            .bind(to: view.rateText)
            .disposed(by: disposeBag)

        amountSubject
            .map { String(format: "%0.2f", $0) }
            .bind(to: view.amountText)
            .disposed(by: disposeBag)
    }
}
