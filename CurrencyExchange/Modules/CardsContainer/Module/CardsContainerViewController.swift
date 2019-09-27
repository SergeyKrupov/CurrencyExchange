//
//  CardsContainerCardsContainerViewController.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol CardsContainerViewProtocol: class {

    func setViewControllers(_ viewControllers: [UIViewController])
}

final class CardsContainerViewController: UIPageViewController, CardsContainerViewProtocol {

    // MARK: - Outlets

    // MARK: - Public
    func setPresenter(_ presenter: CardsContainerPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - CardsContainerViewProtocol
    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.setViewControllers(viewControllers, direction: .forward, animated: false)
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        dataSource = self

        presenter?.setupBindings(self)
    }

    // MARK: - Private
    private var presenter: CardsContainerPresenterProtocol?
}

extension CardsContainerViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.firstIndex(of: viewController) else {
            return nil
        }
        return presenter?.viewController(before: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.firstIndex(of: viewController) else {
            return nil
        }
        return presenter?.viewController(after: index)
    }
}
