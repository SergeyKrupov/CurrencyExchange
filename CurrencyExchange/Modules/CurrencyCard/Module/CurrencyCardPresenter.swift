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

final class CurrencyCardPresenter: CurrencyCardModuleInput {

    // MARK: - Injected properties
    var interactor: CurrencyCardInteractorProtocol!
    var router: CurrencyCardRouterProtocol!
    weak var view: CurrencyCardViewProtocol?
    var currency: Currency!

    // MARK: - CurrencyCardModuleInput
    let amount = BehaviorRelay<Double>(value: 0)

    // MARK: - Private
    private let disposeBag = DisposeBag()
}

// MARK: - CurrencyCardPesenterProtocol
extension CurrencyCardPresenter: CurrencyCardPresenterProtocol {

    func setupBindings(_ view: CurrencyCardViewProtocol) {
        view.setCurrencyName(currency.rawValue)

        let doubleValue = view.amountText
            .map { Double($0) }

        doubleValue
            .drive(Binder(self) { this, value in
                let color: UIColor = value == nil ? .red : .black
                this.view?.setAmountColor(color)
            })
            .disposed(by: disposeBag)

        doubleValue
            .flatMap { Driver.from(optional: $0) }
            .drive(amount)
            .disposed(by: disposeBag)
    }
}
