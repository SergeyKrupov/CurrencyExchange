//
//  ExchangeRateAPI.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Moya

enum ExchangeRateAPI {
    case latest(base: Currency, symbols: [Currency])
}

extension ExchangeRateAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.exchangeratesapi.io")!
    }

    var path: String {
        switch self {
        case .latest:
            return "/latest"
        }
    }

    var method: Method {
        switch self {
        case .latest:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .latest(base, symbols):
            return .requestParameters(
                parameters: [
                    "base": base.rawValue,
                    "symbols": symbols.map { $0.rawValue }
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
