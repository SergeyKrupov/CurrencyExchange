//
//  ConverterConverterPresenter.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ConverterPresenterProtocol {

    func setupBindings(_ view: ConverterViewProtocol)
}

final class ConverterPresenter {

    // MARK: - Injected properties
    var interactor: ConverterInteractorProtocol!
    var router: ConverterRouterProtocol!
    weak var view: ConverterViewProtocol?
    var firstContainerInterface: CardsContainerInterface!
    var secondContainerInterface: CardsContainerInterface!

    // MARK: - Private
    private let disposeBag = DisposeBag()
}

// MARK: - ConverterPesenterProtocol
extension ConverterPresenter: ConverterPresenterProtocol {

    func setupBindings(_ view: ConverterViewProtocol) {

        let currencies: [Currency] = [.usd, .gbp, .eur]

        var rates: [Rate] = []
        var value: Double = 1
        for c1 in currencies {
            for c2 in currencies {
                rates.append(Rate(first: c1, second: c2, rate: c1 == c2 ? 1 : value))
                value += 0.15
            }
        }

        let data = CardsContainerInput(
            balance: [.usd: 100, .gbp: 200, .eur: 300],
            rates: rates,
            counterpart: .usd,
            amount: nil
        )
        firstContainerInterface.input.on(.next(data))

        firstContainerInterface.output
            .debug()
            .subscribe()
            .disposed(by: disposeBag)
    }
}

// MARK: - ConverterModuleInput
extension ConverterPresenter: ConverterModuleInput {
}
