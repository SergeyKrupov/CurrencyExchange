//
//  ExchangeRatesServiceAssembly.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Moya
import Swinject

final class CurrencyServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(MoyaProvider<ExchangeRateAPI>.self) { _ in
            MoyaProvider<ExchangeRateAPI>(
                // FIXME
                // Примечание:
                // с моего компьютера не удаются достучаться до https://api.exchangeratesapi.io/latest поэтому устанавливаю
                // прокси. Если до вышеуказанного есть доступ без прокси, то следующую строчку можно убрать
                manager: createManager()
            )
        }

        container.register(CurrencyService.self) { resolver in
            CurrencyServiceImpl(
                ratesProvider: resolver.resolve(MoyaProvider<ExchangeRateAPI>.self)!,
                timeInterval: .seconds(30)
            )
        }
    }
}

// Workaround (не часть тестового задания)
private func createManager() -> Manager {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders

    let host = "195.162.64.27"
    let port = 39_313

    var proxyConfiguration = [String: AnyObject]()
    proxyConfiguration.updateValue(1 as AnyObject, forKey: "HTTPEnable")
    proxyConfiguration.updateValue(host as AnyObject, forKey: "HTTPProxy")
    proxyConfiguration.updateValue(port as AnyObject, forKey: "HTTPPort")
    proxyConfiguration.updateValue(1 as AnyObject, forKey: "HTTPSEnable")
    proxyConfiguration.updateValue(host as AnyObject, forKey: "HTTPSProxy")
    proxyConfiguration.updateValue(port as AnyObject, forKey: "HTTPSPort")
    configuration.connectionProxyDictionary = proxyConfiguration

    return Manager(configuration: configuration)
}
