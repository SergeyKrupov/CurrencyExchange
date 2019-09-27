//
//  DI.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import SwinjectStoryboard

extension SwinjectStoryboard {

    @objc
    class func setup() {
        ExchangeRatesServiceAssembly().assemble(container: defaultContainer)
        CardsContainerAssembly().assemble(container: defaultContainer)
        ConverterAssembly().assemble(container: defaultContainer)
        CurrencyCardAssembly().assemble(container: defaultContainer)

        defaultContainer.storyboardInitCompleted(UINavigationController.self) { _, _ in
        }
    }
}
