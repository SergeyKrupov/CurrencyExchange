//
//  CardsContainerModule.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject
import UIKit

struct CardsContainerModule {
    let viewController: UIViewController
    let interface: CardsContainerInterface
}

extension CardsContainerModule {

    static func create(resolver: Resolver) -> CardsContainerModule {
        return resolver.resolve(CardsContainerModule.self)!
    }
}
