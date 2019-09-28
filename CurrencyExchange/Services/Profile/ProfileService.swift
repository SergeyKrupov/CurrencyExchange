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
    func updateBalance(block: (Balance) -> Balance)
}

extension ProfileService {

    func observeBalance(for currency: Currency) -> Observable<Double> {
        return observeBalance()
            .flatMap { balance in Observable.from(optional: balance[currency]) }
    }
}

final class ProfileServiceImpl: ProfileService {

    init(_ balance: Balance) {
        balanceRelay = BehaviorRelay(value: balance)
    }

    // MARK: - ProfileService
    func observeBalance() -> Observable<Balance> {
        return balanceRelay.asObservable()
    }

    func updateBalance(block: (Balance) -> Balance) {
        lock.lock()
        defer { lock.unlock() }
        let newBalance = block(balanceRelay.value)
        balanceRelay.accept(newBalance)
    }

    // MARK: - Private
    private let balanceRelay: BehaviorRelay<Balance>
    private let lock = NSRecursiveLock()
}
