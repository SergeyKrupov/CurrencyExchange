//
//  CardsContainerCardsContainerModuleInput.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CardsContainerModuleInput: class {

    // Выбранная валюта (выход)
    var currency: Driver<Currency> { get }
    // Введённое число (вход-выход)
    var amount: PublishRelay<Double> { get }
}
