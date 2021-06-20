//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 18/06/2021.
//

import UIKit
import RxSwift

class WeatherForecastViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: WeatherForecastViewModelInterface
    
    init(viewModel: WeatherForecastViewModelInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.refreshData.onNext(())
    }
    
    private func setupBindings() {
        viewModel.errors.asObservable()
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable()
            .subscribe {
                print($0)
            }.disposed(by: disposeBag)
    }
}

