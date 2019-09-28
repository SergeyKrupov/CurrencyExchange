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

    init(interactor: ConverterInteractorProtocol,
         router: ConverterRouterProtocol,
         view: ConverterViewProtocol,
         firstContainerInterface: CardsContainerInterface,
         secondContainerInterface: CardsContainerInterface) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.firstContainerInterface = firstContainerInterface
        self.secondContainerInterface = secondContainerInterface
    }

    // MARK: - Private
    private let interactor: ConverterInteractorProtocol
    private let router: ConverterRouterProtocol
    private weak var view: ConverterViewProtocol?
    private let firstContainerInterface: CardsContainerInterface
    private let secondContainerInterface: CardsContainerInterface
    private let disposeBag = DisposeBag()
}

// MARK: - ConverterPesenterProtocol
extension ConverterPresenter: ConverterPresenterProtocol {

    func setupBindings(_ view: ConverterViewProtocol) {
        firstContainerInterface.output
            .subscribe(interactor.firstContainerOutput)
            .disposed(by: disposeBag)

        interactor.firstInput
            .bind(to: firstContainerInterface.input)
            .disposed(by: disposeBag)

        secondContainerInterface.output
            .subscribe(interactor.secondContainerOutput)
            .disposed(by: disposeBag)

        interactor.secondInput
            .bind(to: secondContainerInterface.input)
            .disposed(by: disposeBag)
    }
}

// MARK: - ConverterModuleInput
extension ConverterPresenter: ConverterModuleInput {
}
