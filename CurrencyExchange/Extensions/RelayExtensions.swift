//
//  RelayExtensions.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 29/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa

extension PublishRelay {

    func asBinder() -> Binder<Element> {
        return Binder(self) { this, value in
            this.accept(value)
        }
    }
}
