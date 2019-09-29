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

    var firstOutputBinder: Binder<CardsContainerOutput> { get }
    var secondOutputBinder: Binder<CardsContainerOutput> { get }
    var firstInput: Observable<CardsContainerInput> { get }
    var secondInput: Observable<CardsContainerInput> { get }

    var rateObservable: Observable<Rate?> { get }
    var isExchangeEnabled: Observable<Bool> { get }
    var notification: Observable<ConverterNotification> { get }

    func exchange()
}

final class ConverterInteractor: ConverterInteractorProtocol {

    init(currencyService: CurrencyService, profileService: ProfileService) {
        self.currencyService = currencyService
        self.profileService = profileService
        setup()
    }

    // MARK: - ConverterInteractorProtocol
    var firstOutputBinder: Binder<CardsContainerOutput> {
        return firstContainerRelay.asBinder()
    }

    var secondOutputBinder: Binder<CardsContainerOutput> {
        return secondContainerRelay.asBinder()
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

    var notification: Observable<ConverterNotification> {
        return stateRelay
            .flatMap { Observable.from(optional: $0.notification) }
    }

    func exchange() {
        exchangeRelay.accept(())
    }

    // MARK: - Private
    private let currencyService: CurrencyService
    private let profileService: ProfileService
    private let disposeBag = DisposeBag()
    private let firstContainerRelay = PublishRelay<CardsContainerOutput>()
    private let secondContainerRelay = PublishRelay<CardsContainerOutput>()
    private let exchangeRelay = PublishRelay<Void>()
    private let stateRelay = BehaviorRelay<ConverterState>(value: .initialState)

    private func setup() {
        let bindUI: (ObservableSchedulerContext<ConverterState>) -> Observable<ConverterEvent> = bind(self) { this, state in
            let subscriptions: [Disposable] = [
                state.bind(to: this.stateRelay)
            ]

            let events: [Signal<ConverterEvent>] = [
                this.firstContainerRelay.asSignal().map { ConverterEvent.firstInput($0) },
                this.secondContainerRelay.asSignal().map { ConverterEvent.secondInput($0) },
                this.makeExchangeEvent(),
                this.observeRates()
            ]

            return Bindings(subscriptions: subscriptions, events: events)
        }

        let effects: (CurrencyPair) -> Observable<ConverterEvent> = { [service = currencyService] pair in
            service.observeRate(first: pair.first, second: pair.second)
                .map { ConverterEvent.rateObtained($0) }
        }

        Observable.system(
                initialState: ConverterState.initialState,
                reduce: ConverterState.reduce,
                scheduler: MainScheduler.instance,
                feedback: bindUI, react(request: obtainCurrencyPair, effects: effects)
            )
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func observeRates() -> Signal<ConverterEvent> {
        return stateRelay
            .map(obtainCurrencyPair)
            .distinctUntilChanged()
            .flatMapLatest { [service = currencyService] pair -> Observable<ConverterEvent> in
                guard let pair = pair else {
                    return .never()
                }
                return service
                    .observeRate(first: pair.first, second: pair.second)
                    .map { ConverterEvent.rateObtained($0) }
            }
            .asSignal(onErrorSignalWith: .never())
    }

    private func makeExchangeEvent() -> Signal<ConverterEvent> {
        return exchangeRelay
            .withLatestFrom(stateRelay)
            .flatMap { [profileService] state -> Observable<ConverterEvent> in
                return profileService.updateBalance { balance -> Observable<ConverterEvent> in
                    guard let first = balance[state.first.currency], let second = balance[state.second.currency] else {
                        return .empty()
                    }

                    if first + state.first.amount < 0 || second + state.second.amount < 0 {
                        return .just(.exchangeComplete(.notEnoughtMoney))
                    }

                    balance[state.first.currency] = first + state.first.amount
                    balance[state.second.currency] = second + state.second.amount
                    return .just(.exchangeComplete(.exchanged(balance)))
                }
            }
            .asSignal(onErrorSignalWith: .never())
    }
}

private struct CurrencyPair: Equatable {
    let first: Currency
    let second: Currency
}

private func obtainCurrencyPair(_ state: ConverterState) -> CurrencyPair? {
    if state.fixedValue == .second {
        return CurrencyPair(first: state.second.currency, second: state.first.currency)
    } else {
        return CurrencyPair(first: state.first.currency, second: state.second.currency)
    }
}
