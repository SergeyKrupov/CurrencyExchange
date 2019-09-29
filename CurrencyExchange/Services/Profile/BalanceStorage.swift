//
//  ProfileStorage.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 30/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Foundation

protocol BalanceStorage {

    func load() -> Balance?
    func store(_ balance: Balance)
}

final class BalanceStorageImpl: BalanceStorage {

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func load() -> Balance? {
        guard let data = userDefaults.object(forKey: key) as? Data else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode([String: Double].self, from: data)
            let pairs = decoded.compactMap { pair in Currency(rawValue: pair.key).flatMap { ($0, pair.value) } }
            return Balance(uniqueKeysWithValues: pairs)
        } catch {
            assertionFailure("Error: \(error)")
            return nil
        }
    }

    func store(_ balance: Balance) {
        let encoder = JSONEncoder()
        let encodable = Dictionary(uniqueKeysWithValues: balance.map { ($0.key.rawValue, $0.value) })
        do {
            let data = try encoder.encode(encodable)
            userDefaults.set(data, forKey: key)
        } catch {
            assertionFailure("Error: \(error)")
        }
    }

    // MARK: - Private
    private let userDefaults: UserDefaults
    private let key = "Balance"
}
