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

    // MARK: - Properties
    var interactor: ConverterInteractorProtocol!
    var router: ConverterRouterProtocol!
    weak var view: ConverterViewProtocol?

    // MARK: - Private
    private let disposeBag = DisposeBag()
}

// MARK: - ConverterPesenterProtocol
extension ConverterPresenter: ConverterPresenterProtocol {

    func setupBindings(_ view: ConverterViewProtocol) {
    }
}

// MARK: - ConverterModuleInput
extension ConverterPresenter: ConverterModuleInput {
}
