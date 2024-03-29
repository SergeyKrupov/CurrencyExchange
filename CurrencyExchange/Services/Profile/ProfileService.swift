//
//  ProfileService.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 28/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

typealias Balance = [Currency: Double]

protocol ProfileService {

    func observeBalance() -> Observable<Balance>
    func updateBalance<T>(block: (inout Balance) -> T) -> T
}

extension ProfileService {

    func observeBalance(for currency: Currency) -> Observable<Double> {
        return observeBalance()
            .flatMap { balance in Observable.from(optional: balance[currency]) }
    }
}

final class ProfileServiceImpl: ProfileService {

    init(balanceStorage: BalanceStorage, defaultBalance: Balance) {
        balanceRelay = BehaviorRelay(value: balanceStorage.load() ?? defaultBalance)
        self.balanceStorage = balanceStorage
    }

    // MARK: - ProfileService
    func observeBalance() -> Observable<Balance> {
        return balanceRelay.asObservable()
    }

    func updateBalance<T>(block: (inout Balance) -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        var balance = balanceRelay.value
        let result = block(&balance)
        balanceStorage.store(balance)
        balanceRelay.accept(balance)
        return result
    }

    // MARK: - Private
    private let balanceRelay: BehaviorRelay<Balance>
    private let lock = NSRecursiveLock()
    private let balanceStorage: BalanceStorage
}
