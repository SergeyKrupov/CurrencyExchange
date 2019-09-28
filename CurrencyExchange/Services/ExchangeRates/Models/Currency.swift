//
//  Currency.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

// TODO: Вынести в отдельную папку
enum Currency: String, CaseIterable {
    case eur = "EUR"
    case usd = "USD"
    case gbp = "GBP"
}

extension Currency {

    var symbol: String {
        switch self {
        case .eur:
            return "€"
        case .usd:
            return "$"
        case .gbp:
            return "£"
        }
    }
}
