//
//  ConverterRouter.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import UIKit

protocol ConverterRouterProtocol: class {

    func presentAlert(text: String)
}

final class ConverterRouter: ConverterRouterProtocol {

    init(viewController: (UIViewController & ConverterViewProtocol)?) {
        self.viewController = viewController
    }

    // MARK: ConverterRouterProtocol
    func presentAlert(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }

    // MARK: - Private
    private weak var viewController: (UIViewController & ConverterViewProtocol)?
}
