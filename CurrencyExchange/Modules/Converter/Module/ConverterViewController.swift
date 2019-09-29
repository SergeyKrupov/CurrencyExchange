//
//  ConverterConverterViewController.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol ConverterViewProtocol: class {
    // Вход
    var titleBinder: Binder<String?> { get }
    var isExchangeEnabledBinder: Binder<Bool> { get }
    // Выход
    var exchange: Signal<Void> { get }
}

final class ConverterViewController: UIViewController {

    // MARK: - Injected properties
    var presenter: ConverterPresenterProtocol!
    var firstContainer: UIViewController!
    var secondContainer: UIViewController!

    // MARK: - Outlets
    @IBOutlet private var stackView: UIStackView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.setupBindings(self)
    }

    // MARK: - Private
    private lazy var exchangeItem = UIBarButtonItem(title: "Exchange", style: .plain, target: nil, action: nil)

    private func setupUI() {
        firstContainer.willMove(toParent: self)
        stackView.addArrangedSubview(firstContainer.view)
        addChild(firstContainer)

        secondContainer.willMove(toParent: self)
        stackView.addArrangedSubview(secondContainer.view)
        addChild(secondContainer)

        navigationItem.rightBarButtonItem = exchangeItem
    }
}

// MARK: - ConverterViewInput
extension ConverterViewController: ConverterViewProtocol {

    func setupInitialState() {
    }

    var titleBinder: Binder<String?> {
        return navigationItem.rx.title
    }

    var isExchangeEnabledBinder: Binder<Bool> {
        return exchangeItem.rx.isEnabled
    }

    var exchange: Signal<Void> {
        return exchangeItem.rx.tap.asSignal()
    }
}
