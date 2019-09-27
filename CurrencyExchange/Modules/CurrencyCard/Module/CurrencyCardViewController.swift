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

    func setBackgroundColor(_ color: UIColor)
}

final class CurrencyCardViewController: UIViewController {

    // MARK: - Outlets

    // MARK: - Public
    func setPresenter(_ presenter: CurrencyCardPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupBindings(self)
    }

    // MARK: - Private
    private var presenter: CurrencyCardPresenterProtocol?
}

// MARK: - CurrencyCardViewInput
extension CurrencyCardViewController: CurrencyCardViewProtocol {

    func setupInitialState() {
    }

    func setBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}

