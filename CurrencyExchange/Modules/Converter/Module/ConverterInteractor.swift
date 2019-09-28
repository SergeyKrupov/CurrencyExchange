//
//  ConverterConverterInteractor.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxFeedback
import RxSwift

protocol ConverterInteractorProtocol: class {

    var firstContainerOutput: AnyObserver<CardsContainerOutput> { get }
    var secondContainerOutput: AnyObserver<CardsContainerOutput> { get }
    var firstInput: Observable<CardsContainerInput> { get }
    var secondInput: Observable<CardsContainerInput> { get }
}

final class ConverterInteractor: ConverterInteractorProtocol {

    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
        setup()
    }

    // MARK: - ConverterInteractorProtocol
    var firstContainerOutput: AnyObserver<CardsContainerOutput> {
        return AnyObserver(firstContainerSubject)
    }

    var secondContainerOutput: AnyObserver<CardsContainerOutput> {
        return AnyObserver(secondContainerSubject)
    }

    var firstInput: Observable<CardsContainerInput> {
        return stateSubject
            .map { state in
                CardsContainerInput(
                    rate: state.firstRate,
                    counterpart: state.second.currency,
                    amount: state.fixedValue != .first ? state.first.amount : nil
                )
            }
    }

    var secondInput: Observable<CardsContainerInput> {
        return stateSubject
            .map { state in
                CardsContainerInput(
                    rate: state.secondRate,
                    counterpart: state.second.currency,
                    amount: state.fixedValue != .second ? state.second.amount : nil
                )
            }
    }

    // MARK: - Private
    private struct CurrencyPair: Equatable {
        let first: Currency
        let second: Currency
    }

    private let currencyService: CurrencyService
    private let disposeBag = DisposeBag()
    private let firstContainerSubject = PublishSubject<CardsContainerOutput>()
    private let secondContainerSubject = PublishSubject<CardsContainerOutput>()
    private let stateSubject: ReplaySubject<ConverterState> = {
        let subject = ReplaySubject<ConverterState>.create(bufferSize: 1)
        subject.onNext(.initialState)
        return subject
    }()

    private func setup() {

        let bindUI: (ObservableSchedulerContext<ConverterState>) -> Observable<ConverterEvent> = bind(self) { this, state in
            let subscriptions: [Disposable] = [
                state.subscribe(this.stateSubject)
            ]

            let events: [Signal<ConverterEvent>] = [
                this.firstContainerSubject.map { ConverterEvent.firstInput($0) }.asSignal(onErrorSignalWith: .never()),
                this.secondContainerSubject.map { ConverterEvent.secondInput($0) }.asSignal(onErrorSignalWith: .never())
            ]

            return Bindings(subscriptions: subscriptions, events: events)
        }

        let request: (ConverterState) -> CurrencyPair = { state in
            CurrencyPair(first: state.first.currency, second: state.second.currency)
        }

        let effects: (CurrencyPair) -> Observable<ConverterEvent> = { [service = currencyService] pair in
            service.observeRate(first: pair.first, second: pair.second)
                .map { ConverterEvent.rateObtained($0) }
        }

        Observable.system(
                initialState: ConverterState.initialState,
                reduce: ConverterState.reduce,
                scheduler: MainScheduler.instance,
                feedback: bindUI, react(request: request, effects: effects)
            )
            .subscribe()
            .disposed(by: disposeBag)
    }
}
