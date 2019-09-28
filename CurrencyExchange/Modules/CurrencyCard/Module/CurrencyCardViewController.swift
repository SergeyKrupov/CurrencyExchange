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

    var amountText: Driver<String> { get }

    func setCurrencyName(_ name: String)
    func setAmountColor(_ color: UIColor)
}

final class CurrencyCardViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private var currencyLabel: UILabel!
    @IBOutlet private var amountTextField: UITextField!

    // MARK: - Injected properties
    var presenter: CurrencyCardPresenterProtocol!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupBindings(self)
    }

    // MARK: - Private
}

// MARK: - CurrencyCardViewInput
extension CurrencyCardViewController: CurrencyCardViewProtocol {

    var amountText: Driver<String> {
        //FIXME: stored property
        return amountTextField.rx.text.orEmpty.asDriver()
    }

    func setCurrencyName(_ name: String) {
        currencyLabel.text = name
    }

    func setAmountColor(_ color: UIColor) {
        amountTextField.textColor = color
    }
}
