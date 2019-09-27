//
//  RatesResponse.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Foundation

struct RatesResponse: Codable {
    let rates: [String: Double]
    let base: String
}
