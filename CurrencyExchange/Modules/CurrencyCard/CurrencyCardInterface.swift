//
//  CurrencyCardCurrencyCardModuleInput.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

struct CurrencyCardOutput {
    let amount: Double
}

protocol CurrencyCardInterface: class {

    var currency: Currency { get }
    var amount: AnyObserver<Double> { get }
    var rate: AnyObserver<Rate> { get }
    var output: Observable<CurrencyCardOutput> { get }
}
