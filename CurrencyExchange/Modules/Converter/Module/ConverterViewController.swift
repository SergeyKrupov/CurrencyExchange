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
        presenter?.setupBindings(self)

        navigationItem.title = "Converter"

        firstContainer.willMove(toParent: self)
        stackView.addArrangedSubview(firstContainer.view)
        addChild(firstContainer)

        secondContainer.willMove(toParent: self)
        stackView.addArrangedSubview(secondContainer.view)
        addChild(secondContainer)
    }
}

// MARK: - ConverterViewInput
extension ConverterViewController: ConverterViewProtocol {

    func setupInitialState() {
    }
}

