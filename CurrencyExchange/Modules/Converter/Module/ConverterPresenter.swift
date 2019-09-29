//
//  ConverterConverterPresenter.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ConverterPresenterProtocol {

    func setupBindings(_ view: ConverterViewProtocol)
}

final class ConverterPresenter {

    init(interactor: ConverterInteractorProtocol,
         router: ConverterRouterProtocol,
         view: ConverterViewProtocol,
         firstContainerInterface: CardsContainerInterface,
         secondContainerInterface: CardsContainerInterface) {
        self.interactor = interactor
        self.router = router
        self.view = view
        self.firstContainerInterface = firstContainerInterface
        self.secondContainerInterface = secondContainerInterface
    }

    // MARK: - Private
    private let interactor: ConverterInteractorProtocol
    private let router: ConverterRouterProtocol
    private weak var view: ConverterViewProtocol?
    private let firstContainerInterface: CardsContainerInterface
    private let secondContainerInterface: CardsContainerInterface
    private let disposeBag = DisposeBag()
}

// MARK: - ConverterPesenterProtocol
extension ConverterPresenter: ConverterPresenterProtocol {

    func setupBindings(_ view: ConverterViewProtocol) {
        firstContainerInterface.output
            .subscribe(interactor.firstOutputBinder)
            .disposed(by: disposeBag)

        interactor.firstInput
            .bind(to: firstContainerInterface.input)
            .disposed(by: disposeBag)

        secondContainerInterface.output
            .subscribe(interactor.secondOutputBinder)
            .disposed(by: disposeBag)

        interactor.secondInput
            .bind(to: secondContainerInterface.input)
            .disposed(by: disposeBag)

        interactor.rateObservable
            .map { $0?.toString() }
            .bind(to: view.titleBinder)
            .disposed(by: disposeBag)

        interactor.isExchangeEnabled
            .bind(to: view.isExchangeEnabledBinder)
            .disposed(by: disposeBag)

        interactor.notification
            .bind(to: Binder(self) { this, notification in
                let message: String
                switch notification {
                case .notEnoughtMoney:
                    message = "Not enought money"
                case let .exchanged(balance):
                    let balanceText = balance
                        .map { String(format: "%@ → %0.2f", $0.key.rawValue, $0.value) }
                        .joined(separator: "\n")

                    message = """
                        Completed

                        \(balanceText)
                    """
                }
                this.router.presentAlert(text: message)
            })
            .disposed(by: disposeBag)

        view.exchange
            .emit(to: Binder(self) { this, _ in
                this.interactor.exchange()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ConverterModuleInput
extension ConverterPresenter: ConverterModuleInput {
}
