//
//  ConverterAssembly.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class ConverterAssembly: Assembly {

    func assemble(container: Container) {
        container.storyboardInitCompleted(ConverterViewController.self) { resolver, viewController in

            let firstContainer = CardsContainerModule.create(resolver: resolver)
            let secondContainer = CardsContainerModule.create(resolver: resolver)

            let router = ConverterRouter()

            let interactor = ConverterInteractor(
                currencyService: resolver.resolve(CurrencyService.self)!
            )

            let presenter = ConverterPresenter(
                interactor: interactor,
                router: router,
                view: viewController,
                firstContainerInterface: firstContainer.interface,
                secondContainerInterface: secondContainer.interface
            )

            viewController.presenter = presenter
            viewController.firstContainer = firstContainer.viewController
            viewController.secondContainer = secondContainer.viewController
        }
    }
}
