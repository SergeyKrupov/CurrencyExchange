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

    func viewController(before viewContoller: UIViewController) -> UIViewController?
    func viewController(after viewContoller: UIViewController) -> UIViewController?
}

final class CardsContainerPresenter {

    // MARK: - Injected properties
    var interactor: CardsContainerInteractorProtocol!
    var router: CardsContainerRouterProtocol!
    weak var view: CardsContainerViewProtocol?
    var modules: [CurrencyCardModule]!

    // MARK: - Private
    private let disposeBag = DisposeBag()
}

// MARK: - CardsContainerPesenterProtocol
extension CardsContainerPresenter: CardsContainerPresenterProtocol {
    func setupBindings(_ view: CardsContainerViewProtocol) {
        if let viewController = modules.first?.viewController {
            view.setViewController(viewController)
        }
    }

    func viewController(before index: Int) -> UIViewController {
        let newIndex = (index + modules.count - 1) % modules.count
        return modules[newIndex].viewController
    }

    func viewController(before viewContoller: UIViewController) -> UIViewController? {
        guard let index = modules.firstIndex(where: { $0.viewController === viewContoller }) else {
            return nil
        }
        let nextIndex = (index + modules.count - 1) % modules.count
        return modules[nextIndex].viewController
    }

    func viewController(after viewContoller: UIViewController) -> UIViewController? {
        guard let index = modules.firstIndex(where: { $0.viewController === viewContoller }) else {
            return nil
        }
        let nextIndex = (index + 1) % modules.count
        return modules[nextIndex].viewController
    }
}
