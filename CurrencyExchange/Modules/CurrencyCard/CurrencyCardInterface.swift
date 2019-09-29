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

    var currency: Currency { get }
    var amount: Double { get }

    var amountBinder: Binder<Double> { get }
    var rateBinder: Binder<Rate> { get }

    func observeAmount() -> Observable<Double>
}
