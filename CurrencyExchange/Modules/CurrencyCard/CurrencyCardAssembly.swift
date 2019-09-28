//
//  CurrencyCardAssembly.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class CurrencyCardAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CurrencyCardModule.self) { (resolver: Resolver, currency: Currency) -> CurrencyCardModule in
            let viewController = CurrencyCardViewController()
            let interactor = CurrencyCardInteractor()
            let router = CurrencyCardRouter()
            let presenter = CurrencyCardPresenter(currency: currency)

            presenter.view = viewController
            presenter.interactor = interactor
            presenter.router = router

            viewController.presenter = presenter

            return CurrencyCardModule(
                viewController: viewController,
                interface: presenter
            )
        }
        .inObjectScope(.transient)
    }
}
