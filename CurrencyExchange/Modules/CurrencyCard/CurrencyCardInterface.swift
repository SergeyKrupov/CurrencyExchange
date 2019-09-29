//
//  CurrencyCardCurrencyCardModuleInput.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CurrencyCardInterface: class {

    // Вход:
    var amountBinder: Binder<Double> { get }
    var rateBinder: Binder<Rate> { get }

    // Выход:
    var currency: Currency { get }
    var amount: Double { get }

    func observeAmount() -> Observable<Double>
}
