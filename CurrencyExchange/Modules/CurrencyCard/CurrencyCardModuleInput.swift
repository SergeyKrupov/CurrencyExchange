//
//  CurrencyCardCurrencyCardModuleInput.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CurrencyCardModuleInput: class {

    // Валюта (вход)
    var currency: AnyObserver<Currency> { get }

    // Введённое число (вход-выход)
    var amount: BehaviorRelay<Double> { get }
}
