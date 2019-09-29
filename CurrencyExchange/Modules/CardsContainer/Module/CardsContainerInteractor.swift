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

    init(modules: [CurrencyCardModule], currencyService: CurrencyService) {
        self.modules = modules
        self.currencyService = currencyService
        bindModulesInput()
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
        activeModuleIndex.accept(index)
    }

    // MARK: - Private
    private let modules: [CurrencyCardModule]
    private let currencyService: CurrencyService
    private let inputSubject = ReplaySubject<CardsContainerInput>.create(bufferSize: 1)
    private let outputSubject = PublishSubject<CardsContainerOutput>()

    private var activeModuleIndex = BehaviorRelay(value: 0)
    private let disposeBag = DisposeBag()

    private func bindModulesInput() {
        for module in modules {
            let currency = module.interface.currency

            inputSubject
                .flatMap { [service = currencyService] in service.observeRate(first: currency, second: $0.counterpart) }
                .bind(to: module.interface.rateBinder)
                .disposed(by: disposeBag)

            inputSubject
                .flatMap { Observable.from(optional: $0.amount) }
                .bind(to: module.interface.amountBinder)
                .disposed(by: disposeBag)
        }
    }

    private func bindModulesOutput() {
        activeModuleIndex
            .flatMapLatest { [modules] index -> Observable<CardsContainerOutput> in
                let module = modules[index]
                let currency = module.interface.currency
                let amount = module.interface.amount
                return module.interface.observeAmount()
                    .startWith(amount)
                    .map { CardsContainerOutput(amount: $0, currency: currency) }
            }
            .bind(to: outputSubject)
            .disposed(by: disposeBag)
    }
}
