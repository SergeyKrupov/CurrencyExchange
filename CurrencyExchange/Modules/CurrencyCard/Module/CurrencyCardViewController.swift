//
//  CurrencyCardCurrencyCardViewController.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol CurrencyCardViewProtocol: class {

    var balanceText: Binder<String?> { get }
    var rateText: Binder<String?> { get }
    var amountText: ControlProperty<String> { get }

    func setCurrencyName(_ name: String)
    func setAmountColor(_ color: UIColor)
}

final class CurrencyCardViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private var currencyLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var rateLabel: UILabel!
    @IBOutlet private var containerView: UIView!

    // MARK: - Injected properties
    var presenter: CurrencyCardPresenterProtocol!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.setupBindings(self)
    }

    // MARK: - Private
    private func setupUI() {
        containerView.backgroundColor = .white

        let layer = containerView.layer
        layer.borderColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 2, height: 2)

        rateLabel.text = nil
    }
}

// MARK: - CurrencyCardViewInput
extension CurrencyCardViewController: CurrencyCardViewProtocol {

    var balanceText: Binder<String?> {
        return balanceLabel.rx.text
    }

    var rateText: Binder<String?> {
        return rateLabel.rx.text
    }

    var amountText: ControlProperty<String> {
        return amountTextField.rx.text.orEmpty
    }

    func setCurrencyName(_ name: String) {
        currencyLabel.text = name
    }

    func setAmountColor(_ color: UIColor) {
        amountTextField.textColor = color
    }
}
