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

    var startViewController: UIViewController? { get }
    var input: AnyObserver<CardsContainerInput> { get }
    var output: Observable<CardsContainerOutput> { get }

    func viewController(before viewContoller: UIViewController) -> UIViewController?
    func viewController(after viewContoller: UIViewController) -> UIViewController?
    func didSwitchTo(viewController: UIViewController?)
}

final class CardsContainerInteractor: CardsContainerInteractorProtocol {

    init(modules: [CurrencyCardModule]) {
        self.modules = modules
        modules.forEach(bindModuleInput)
        bindModulesOutput()
    }

    // MARK: - CardsContainerInteractorProtocol
    var startViewController: UIViewController? {
        return modules.first?.viewController
    }

    var input: AnyObserver<CardsContainerInput> {
        return AnyObserver(inputSubject)
    }

    var output: Observable<CardsContainerOutput> {
        return outputSubject
    }

    func viewController(before viewContoller: UIViewController) -> UIViewController? {
        guard let index = modules.firstIndex(where: { $0.viewController === viewContoller }) else {
            return nil
        }
        let nextIndex = (index + modules.count - 1) % modules.count
        return modules[nextIndex].viewController
    }

    func viewController(after viewContoller: UIViewController) -> UIViewController? {
        guard let index = modules.firstIndex(where: { $0.viewController === viewContoller }) else {
            return nil
        }
        let nextIndex = (index + 1) % modules.count
        return modules[nextIndex].viewController
    }

    func didSwitchTo(viewController: UIViewController?) {
        guard let index = modules.firstIndex(where: { $0.viewController == viewController }) else {
            return
        }
        activeModuleIndex = index
    }

    // MARK: - Private
    private let modules: [CurrencyCardModule]
    private let inputSubject = ReplaySubject<CardsContainerInput>.create(bufferSize: 1)
    private let outputSubject = PublishSubject<CardsContainerOutput>()

    private var activeModuleIndex: Int = 0
    private let disposeBag = DisposeBag()

    private func bindModuleInput(_ module: CurrencyCardModule) {
        let currency = module.interface.currency

        let balance = inputSubject
            .flatMap { data in Observable.from(optional: data.balance[currency]) }

        let rate = inputSubject
            .flatMap { data -> Observable<Rate> in
                let rate = data.rates.first { $0.first == currency && $0.second == data.counterpart }
                return Observable.from(optional: rate)
            }

        let amount = inputSubject
            .flatMap { Observable.from(optional: $0.amount) }

        Observable.combineLatest(amount, balance, rate, resultSelector: CurrencyCardInput.init)
            .bind(to: module.interface.input)
            .disposed(by: disposeBag)
    }

    private func bindModulesOutput() {
        let observables = modules.map { module -> Observable<CardsContainerOutput> in
            let currency = module.interface.currency
            return module.interface.output
                .map { CardsContainerOutput(amount: $0.amount, currency: currency) }
        }

        Observable.merge(observables)
            .bind(to: outputSubject)
            .disposed(by: disposeBag)
    }
}
