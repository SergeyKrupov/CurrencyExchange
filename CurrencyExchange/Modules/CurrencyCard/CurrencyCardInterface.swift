//
//  CurrencyCardCurrencyCardModuleInput.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

struct CurrencyCardInput {
    let amount: Double
    let balance: Double
    let rate: Rate
}

struct CurrencyCardOutput {
    let amount: Double
}

protocol CurrencyCardInterface: class {

    var currency: Currency { get }
    var input: AnyObserver<CurrencyCardInput> { get }
    var output: Observable<CurrencyCardOutput> { get }
}
