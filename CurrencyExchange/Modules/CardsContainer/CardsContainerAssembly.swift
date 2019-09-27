//
//  CardsContainerAssembly.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class CardsContainerAssembly: Assembly {

    func assemble(container: Container) {

        container.register(CardsContainerModule.self) { resolver -> CardsContainerModule in
            let viewController = CardsContainerViewController()
            let interactor = CardsContainerInteractor()
            let presenter = CardsContainerPresenter()
            let router = CardsContainerRouter()

            let eurModule = resolver.resolve(CurrencyCardModule.self)!
            let gbpModule = resolver.resolve(CurrencyCardModule.self)!
            let usdModule = resolver.resolve(CurrencyCardModule.self)!

            presenter.view = viewController
            presenter.interactor = interactor
            presenter.router = router
            presenter.modules = [eurModule, usdModule, gbpModule]

            viewController.setPresenter(presenter)

            return CardsContainerModule(viewController: viewController, input: interactor)
        }
        .inObjectScope(.transient)
    }
}
