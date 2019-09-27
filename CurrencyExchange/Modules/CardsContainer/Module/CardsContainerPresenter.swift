//
//  CardsContainerCardsContainerPresenter.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CardsContainerPresenterProtocol {

    func setupBindings(_ view: CardsContainerViewProtocol)

    func viewController(before index: Int) -> UIViewController
    func viewController(after index: Int) -> UIViewController
}

final class CardsContainerPresenter {

    // MARK: - Properties
    var interactor: CardsContainerInteractorProtocol!
    var router: CardsContainerRouterProtocol!
    weak var view: CardsContainerViewProtocol?
    var modules: [CurrencyCardModule]!

    // MARK: - Private
    private let disposeBag = DisposeBag()
}

// MARK: - CardsContainerPesenterProtocol
extension CardsContainerPresenter: CardsContainerPresenterProtocol {

    func viewController(before index: Int) -> UIViewController {
        let newIndex = (index + modules.count - 1) % modules.count
        return modules[newIndex].viewController
    }

    func viewController(after index: Int) -> UIViewController {
        let newIndex = (index + 1) % modules.count
        return modules[newIndex].viewController
    }

    func setupBindings(_ view: CardsContainerViewProtocol) {
        view.setViewControllers([modules.first!.viewController])
    }
}
