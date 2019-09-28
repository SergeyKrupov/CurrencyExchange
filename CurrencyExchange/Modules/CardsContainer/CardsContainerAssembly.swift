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
            let eurModule = CurrencyCardModule.create(resolver: resolver, currency: .eur)
            let gbpModule = CurrencyCardModule.create(resolver: resolver, currency: .gbp)
            let usdModule = CurrencyCardModule.create(resolver: resolver, currency: .usd)

            let viewController = CardsContainerViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            let interactor = CardsContainerInteractor(modules: [eurModule, usdModule, gbpModule])
            let presenter = CardsContainerPresenter()
            let router = CardsContainerRouter()

            presenter.view = viewController
            presenter.interactor = interactor
            presenter.router = router

            viewController.presenter = presenter

            return CardsContainerModule(viewController: viewController, interface: presenter)
        }
        .inObjectScope(.transient)
    }
}
