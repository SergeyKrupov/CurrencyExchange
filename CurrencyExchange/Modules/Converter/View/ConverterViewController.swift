//
//  ConverterConverterViewController.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class ConverterViewController: UIViewController {

    // MARK: - Outlets

    // MARK: - Public
    func setPresenter(_ presenter: ConverterPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupBindings(self)
    }

    // MARK: - Private
    private var presenter: ConverterPresenterProtocol?
}

// MARK: - ConverterViewInput
extension ConverterViewController: ConverterViewProtocol {

    func setupInitialState() {
    }
}

