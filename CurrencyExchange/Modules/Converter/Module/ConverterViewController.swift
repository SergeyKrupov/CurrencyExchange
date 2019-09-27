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

    var firstContainer: UIViewController!
    var secondContainer: UIViewController!

    // MARK: - Outlets
    @IBOutlet private var stackView: UIStackView!

    // MARK: - Public
    func setPresenter(_ presenter: ConverterPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupBindings(self)

        navigationItem.title = "Converter"

        firstContainer.willMove(toParent: self)
        stackView.addArrangedSubview(firstContainer.view)
//        view.addSubview(firstContainer.view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            firstContainer.view.topAnchor.constraint(equalTo: view.topAnchor),
//            firstContainer.view.leftAnchor.constraint(equalTo: view.leftAnchor),
//            firstContainer.view.rightAnchor.constraint(equalTo: view.rightAnchor),
//            firstContainer.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
//        ])
        addChild(firstContainer)

        secondContainer.view.backgroundColor = .blue
        secondContainer.willMove(toParent: self)
        stackView.addArrangedSubview(secondContainer.view)
        addChild(secondContainer)

    }

    // MARK: - Private
    private var presenter: ConverterPresenterProtocol?
}

// MARK: - ConverterViewInput
extension ConverterViewController: ConverterViewProtocol {

    func setupInitialState() {
    }
}

