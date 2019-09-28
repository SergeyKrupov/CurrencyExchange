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
    func didSwitchTo(viewController: UIViewController?)
}

final class CardsContainerPresenter: CardsContainerInterface {

    // MARK: - Injected properties
    var interactor: CardsContainerInteractorProtocol!
    var router: CardsContainerRouterProtocol!
    weak var view: CardsContainerViewProtocol?

    // MARK: - CardsContainerModuleInput
    var input: AnyObserver<CardsContainerInput> {
        return interactor.input
    }
    var output: Observable<CardsContainerOutput> {
        return interactor.output
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()
}

// MARK: - CardsContainerPesenterProtocol
extension CardsContainerPresenter: CardsContainerPresenterProtocol {

    func setupBindings(_ view: CardsContainerViewProtocol) {
        if let viewController = interactor.startViewController {
            view.setViewController(viewController)
        }

    }

    func viewController(before viewContoller: UIViewController) -> UIViewController? {
        return interactor.viewController(before: viewContoller)
    }

    func viewController(after viewContoller: UIViewController) -> UIViewController? {
        return interactor.viewController(after: viewContoller)
    }

    func didSwitchTo(viewController: UIViewController?) {
        interactor.didSwitchTo(viewController: viewController)
    }
}
