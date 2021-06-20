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
    private let stackView = UIStackView()
    
    init(viewModel: WeatherForecastViewModelInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        setupBindings()
        layout()
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
            .append(weak: self)
            .subscribe { vc, data in
                vc.navigationItem.title = "Weather forecast for \(data.city)"
                data.temperatureForecasts.forEach {
                    vc.stackView.addArrangedSubview(DayForecastView(viewData: $0))
                }
            }.disposed(by: disposeBag)
    }
    
    private func layout() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
    }
}

