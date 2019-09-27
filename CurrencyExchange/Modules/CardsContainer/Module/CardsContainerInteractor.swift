//
//  CardsContainerCardsContainerInteractor.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

protocol CardsContainerInteractorProtocol: class {

}

final class CardsContainerInteractor: CardsContainerInteractorProtocol, CardsContainerModuleInput {

    private(set) lazy var currency: Driver<Currency> = currencyRelay.asDriver()
    let amount = PublishRelay<Double>()

    // MARK: - Private
    private let currencyRelay = BehaviorRelay<Currency>(value: .eur)
}
