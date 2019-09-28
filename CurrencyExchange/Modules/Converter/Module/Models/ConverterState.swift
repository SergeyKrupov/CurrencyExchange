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
    var balance: [Currency: Double]
    var rates: [Rate]?
    var fixedValue: FixedValue?
}

extension ConverterState {

    static let initialState = ConverterState(
        first: CardsContainerOutput(amount: 0, currency: .usd),
        second: CardsContainerOutput(amount: 0, currency: .eur),
        balance: [.eur: 100, .gbp: 100, .usd: 100],
        rates: makeRates(),
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
        }
        return newState
    }
}

//FIXME: remove
private func makeRates() -> [Rate] {
    let currencies: [Currency] = [.usd, .gbp, .eur]
    var rates: [Rate] = []
    var value: Double = 1
    for c1 in currencies {
        for c2 in currencies {
            rates.append(Rate(first: c1, second: c2, rate: c1 == c2 ? 1 : value))
            value += 0.15
        }
    }
    return rates
}
