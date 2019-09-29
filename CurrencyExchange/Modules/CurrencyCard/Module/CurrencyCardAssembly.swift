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
            let router = CurrencyCardRouter()

            let interactor = CurrencyCardInteractor(
                currency: currency,
                profileService: resolver.resolve(ProfileService.self)!
            )

            let presenter = CurrencyCardPresenter(
                interactor: interactor,
                router: router,
                view: viewController
            )

            viewController.presenter = presenter

            return CurrencyCardModule(
                viewController: viewController,
                interface: presenter
            )
        }
        .inObjectScope(.transient)
    }
}
