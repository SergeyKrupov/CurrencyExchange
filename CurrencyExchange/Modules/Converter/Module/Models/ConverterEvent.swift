//
//  ConverterEvent.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 28/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

enum ConverterEvent {
    case firstInput(CardsContainerOutput)
    case secondInput(CardsContainerOutput)
    case rateObtained(Rate)
}
