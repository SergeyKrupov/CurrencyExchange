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

    // MARK: - Properties
    var interactor: CurrencyCardInteractorProtocol!
    var router: CurrencyCardRouterProtocol!
    weak var view: CurrencyCardViewProtocol?

    // MARK: - CurrencyCardModuleInput
    private(set) lazy var currency: AnyObserver<Currency> = AnyObserver(currencySubject)
    let amount = BehaviorRelay<Double>(value: 0)

    // MARK: - Private
    private let disposeBag = DisposeBag()
    private let currencySubject = ReplaySubject<Currency>.create(bufferSize: 1)

}

// MARK: - CurrencyCardPesenterProtocol
extension CurrencyCardPresenter: CurrencyCardPresenterProtocol {

    func setupBindings(_ view: CurrencyCardViewProtocol) {

        currencySubject
            .subscribe(onNext: { [weak self] currency in
                switch currency {
                case .eur:
                    self?.view?.setBackgroundColor(.red)
                case .usd:
                    self?.view?.setBackgroundColor(.green)
                case .gbp:
                    self?.view?.setBackgroundColor(.blue)
                }
            })
            .disposed(by: disposeBag)
    }
}
