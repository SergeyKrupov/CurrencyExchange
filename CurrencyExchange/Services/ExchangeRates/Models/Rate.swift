//
//  Rate.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 28/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

struct Rate {
    let first: Currency
    let second: Currency
    let rate: Double
}

extension Rate {

    func toString() -> String {
        return String(format: "%@1 = %@%0.2f", first.symbol, rate, second.symbol)
    }
}
