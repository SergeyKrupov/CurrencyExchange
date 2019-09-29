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

    func updateTitle(_ title: String?)
    func setExchangeEnabled(_ enabled: Bool)
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
    private func setupUI() {
        firstContainer.willMove(toParent: self)
        stackView.addArrangedSubview(firstContainer.view)
        addChild(firstContainer)

        secondContainer.willMove(toParent: self)
        stackView.addArrangedSubview(secondContainer.view)
        addChild(secondContainer)
    }

    @objc
    private func exchangeTap(_ :Any) {
        presenter.exchange()
    }
}

// MARK: - ConverterViewInput
extension ConverterViewController: ConverterViewProtocol {

    func setupInitialState() {
    }

    func updateTitle(_ title: String?) {
        navigationItem.title = title
    }

    func setExchangeEnabled(_ enabled: Bool) {
        if enabled {
            let item = UIBarButtonItem(title: "Exchange", style: UIBarButtonItem.Style.plain, target: self, action: #selector(exchangeTap(_:)))
            navigationItem.rightBarButtonItem = item
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
}
