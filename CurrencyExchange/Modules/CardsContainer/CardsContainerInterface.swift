//
//  CardsContainerCardsContainerModuleInput.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

struct CardsContainerInput {
    let counterpart: Currency
    let amount: Double?
}

struct CardsContainerOutput {
    var amount: Double
    var currency: Currency
}

protocol CardsContainerInterface: class {

    var input: AnyObserver<CardsContainerInput> { get }
    var output: Observable<CardsContainerOutput> { get }
}
