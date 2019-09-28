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

    func setViewController(_ viewController: UIViewController)
}

final class CardsContainerViewController: UIPageViewController, CardsContainerViewProtocol {

    // MARK: - Outlets

    // MARK: - Injected properties
    var presenter: CardsContainerPresenterProtocol!

    // MARK: - CardsContainerViewProtocol
    func setViewController(_ viewController: UIViewController) {
        self.setViewControllers([viewController], direction: .forward, animated: false)
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter!.setupBindings(self)
    }

    // MARK: - Private
    private func setupUI() {
        dataSource = self
        delegate = self
    }
}

extension CardsContainerViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return presenter.viewController(before: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return presenter.viewController(after: viewController)
    }
}

extension CardsContainerViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        presenter.didSwitchTo(viewController: pageViewController.viewControllers?.first)
    }
}
