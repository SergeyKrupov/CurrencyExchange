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
