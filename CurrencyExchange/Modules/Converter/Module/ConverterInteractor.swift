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

    var rateObservable: Observable<Rate?> { get }
    var isExchangeEnabled: Observable<Bool> { get }

    func exchange()
}

final class ConverterInteractor: ConverterInteractorProtocol {

    init(currencyService: CurrencyService, profileService: ProfileService) {
        self.currencyService = currencyService
        self.profileService = profileService
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
        return stateRelay
            .map { state in
                CardsContainerInput(
                    counterpart: state.second.currency,
                    amount: state.fixedValue != .first ? state.first.amount : nil
                )
            }
    }

    var secondInput: Observable<CardsContainerInput> {
        return stateRelay
            .map { state in
                CardsContainerInput(
                    counterpart: state.second.currency,
                    amount: state.fixedValue != .second ? state.second.amount : nil
                )
            }
    }

    var rateObservable: Observable<Rate?> {
        return stateRelay
            .map { $0.rate }
    }

    var isExchangeEnabled: Observable<Bool> {
        return stateRelay
            .map { state in
                abs(state.first.amount) > 0.01 && state.first.currency != state.second.currency
            }
    }

    func exchange() {
        exchangeRelay.accept(())
    }

    // MARK: - Private
    private struct CurrencyPair: Equatable {
        let first: Currency
        let second: Currency
    }

    private let currencyService: CurrencyService
    private let profileService: ProfileService
    private let disposeBag = DisposeBag()
    private let firstContainerSubject = PublishSubject<CardsContainerOutput>()
    private let secondContainerSubject = PublishSubject<CardsContainerOutput>()
    private let exchangeRelay = PublishRelay<Void>()
    private let stateRelay = BehaviorRelay<ConverterState>(value: .initialState)

    private func setup() {

        let exchangeEvent = exchangeRelay
            .withLatestFrom(Observable.combineLatest(profileService.observeBalance(), stateRelay.asObservable()))
            .flatMap { tuple -> Observable<ConverterEvent> in
                let (balance, state) = tuple
                return .never()
            }
            .asSignal(onErrorSignalWith: .never())

        let bindUI: (ObservableSchedulerContext<ConverterState>) -> Observable<ConverterEvent> = bind(self) { this, state in
            let subscriptions: [Disposable] = [
                state.bind(to: this.stateRelay)
            ]

            let events: [Signal<ConverterEvent>] = [
                this.firstContainerSubject.map { ConverterEvent.firstInput($0) }.asSignal(onErrorSignalWith: .never()), // todo: signal?
                this.secondContainerSubject.map { ConverterEvent.secondInput($0) }.asSignal(onErrorSignalWith: .never()),
                exchangeEvent,
                this.observeRates()
            ]

            return Bindings(subscriptions: subscriptions, events: events)
        }

        // TODO: убрать дублирование
        let request: (ConverterState) -> CurrencyPair? = { state in
            if state.fixedValue == .second {
                return CurrencyPair(first: state.second.currency, second: state.first.currency)
            } else {
                return CurrencyPair(first: state.first.currency, second: state.second.currency)
            }
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

    private func observeRates() -> Signal<ConverterEvent> {
        return stateRelay
            .map { state -> CurrencyPair? in
                if state.fixedValue == .second {
                    return CurrencyPair(first: state.second.currency, second: state.first.currency)
                } else {
                    return CurrencyPair(first: state.first.currency, second: state.second.currency)
                }
            }
            .distinctUntilChanged()
            .flatMapLatest { [service = currencyService] pair -> Observable<ConverterEvent> in
                guard let pair = pair else {
                    return .never()
                }
                return service.observeRate(first: pair.first, second: pair.second)
                    .map { ConverterEvent.rateObtained($0) }
            }
            .asSignal(onErrorSignalWith: .never())
    }
}
