//
//  ProfileServiceAssembly.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 28/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject

final class ProfileServiceAssembly: Assembly {

    static let startBalanceName = "StartBalance"

    func assemble(container: Container) {

        container.register(Balance.self, name: ProfileServiceAssembly.startBalanceName) { _ -> Balance in
            return [.eur: 100, .gbp: 100, .usd: 100]
        }

        container.register(ProfileService.self) { resolver in
            ProfileServiceImpl(
                resolver.resolve(Balance.self, name: ProfileServiceAssembly.startBalanceName)!
            )
        }
    }
}
