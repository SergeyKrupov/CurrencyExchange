//
//  ConverterState.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 28/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

struct ConverterState {

    enum FixedValue {
        case first, second
    }

    var first: CardsContainerOutput
    var second: CardsContainerOutput
    var fixedValue: FixedValue?
    var rate: Rate?
    var notification: ConverterNotification?
}

extension ConverterState {

    static let initialState = ConverterState(
        first: CardsContainerOutput(amount: 0, currency: .eur),
        second: CardsContainerOutput(amount: 0, currency: .eur),
        fixedValue: nil,
        rate: nil,
        notification: nil
    )

    static func reduce(state: ConverterState, event: ConverterEvent) -> ConverterState {
        var newState = state
        newState.notification = nil

        switch event {
        case let .firstInput(input):
            newState.fixedValue = .first
            newState.first = input

            let rate = state.rate?.rate ?? 0
            newState.second.amount = -input.amount * rate

            if state.first.currency != input.currency { // Обновление курса, если поменялась валюта
                newState.rate = nil
            }
        case let .secondInput(input):
            newState.fixedValue = .second
            newState.second = input

            let rate = state.rate?.rate ?? 0
            newState.first.amount = -input.amount * rate

            if state.second.currency != input.currency { // Обновление курса, если поменялась валюта
                newState.rate = nil
            }
        case let .rateObtained(rate):
            newState.rate = rate
            if state.fixedValue != .second {
                newState.second.amount = -state.first.amount * rate.rate
            } else {
                newState.first.amount = -state.second.amount * rate.rate
            }
        case let .exchangeComplete(notification):
            newState.first.amount = 0
            newState.second.amount = 0
            newState.notification = notification
        }
        return newState
    }
}
