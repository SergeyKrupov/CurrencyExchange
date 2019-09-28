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
    var firstRate: Rate?
    var second: CardsContainerOutput
    var secondRate: Rate?
    var fixedValue: FixedValue?
}

extension ConverterState {

    static let initialState = ConverterState(
        first: CardsContainerOutput(amount: 0, currency: .usd),
        firstRate: nil,
        second: CardsContainerOutput(amount: 0, currency: .eur),
        secondRate: nil,
        fixedValue: nil
    )

    static func reduce(state: ConverterState, event: ConverterEvent) -> ConverterState {
        var newState = state
        switch event {
        case let .firstInput(input):
            newState.fixedValue = .first
            newState.first = input
            newState.second = CardsContainerOutput(amount: -newState.first.amount, currency: newState.second.currency)
        case let .secondInput(input):
            newState.fixedValue = .second
            newState.second = input
            newState.first = CardsContainerOutput(amount: -newState.second.amount, currency: newState.first.currency)
        case let .rateObtained(rate):
            newState.firstRate = rate
            newState.secondRate = rate.inverted
        }
        return newState
    }
}
