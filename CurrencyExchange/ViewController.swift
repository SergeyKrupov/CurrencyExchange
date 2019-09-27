//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Sergey V. Krupov on 27/09/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UIViewController {

    var service: ExchangeRatesService!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        service.observeRate(base: .eur)
            .debug()
            .subscribe()
            .disposed(by: disposeBag)
    }

    let disposeBag = DisposeBag()
}
