//
//  ConverterConverterAssemblyContainer.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class ConverterAssemblyContainer: Assembly {

    func assemble(container: Container) {
        container.register(ConverterInteractorProtocol.self) { resolver in
            let interactor = ConverterInteractor()
            return interactor
        }

        container.register(ConverterRouterProtocol.self) { (resolver, viewController: ConverterViewController) in
            let router = ConverterRouter()
            return router
        }

        container.register(ConverterPresenter.self) { (resolver, viewController: ConverterViewController) in
            let presenter = ConverterPresenter()
            presenter.view = viewController
            presenter.interactor = resolver.resolve(ConverterInteractorProtocol.self)
            presenter.router = resolver.resolve(ConverterRouterProtocol.self, argument: viewController)
            return presenter
        }

        container.storyboardInitCompleted(ConverterViewController.self) { resolver, viewController in
            let presenter = resolver.resolve(ConverterPresenter.self, argument: viewController)!
            viewController.setPresenter(presenter)
        }
    }
}