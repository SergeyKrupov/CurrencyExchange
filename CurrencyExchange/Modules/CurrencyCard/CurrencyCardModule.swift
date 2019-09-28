//
//  CurrencyCardModule.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 28/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject
import UIKit

struct CurrencyCardModule {
    let viewController: UIViewController
    let input: CurrencyCardModuleInput
}

extension CurrencyCardModule {

    static func create(resolver: Resolver, currency: Currency) -> CurrencyCardModule {
        return resolver.resolve(CurrencyCardModule.self, argument: currency)!
    }
}
