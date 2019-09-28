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

            let interactor = ConverterInteractor()
            let presenter = ConverterPresenter()
            let router = ConverterRouter()

            presenter.view = viewController
            presenter.interactor = interactor
            presenter.router = router

            viewController.presenter = presenter
            viewController.firstContainer = firstContainer.viewController
            viewController.secondContainer = secondContainer.viewController
        }
    }
}
