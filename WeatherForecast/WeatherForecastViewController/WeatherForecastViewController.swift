//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 18/06/2021.
//

import UIKit
import RxSwift

class WeatherForecastViewController: UIViewController {
    private struct Values {
        static let spacing: CGFloat = 10
    }
    private let disposeBag = DisposeBag()
    private let viewModel: WeatherForecastViewModelInterface
    private let stackView = UIStackView()
    
    init(viewModel: WeatherForecastViewModelInterface) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Values.spacing
        
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
                vc.stackView.addArrangedSubview(ForecastStatsView(stats: data.stats))
                data.dayForecasts.forEach {
                    vc.stackView.addArrangedSubview(DayForecastView(viewData: $0))
                }
            }.disposed(by: disposeBag)
    }
    
    private func layout() {
        let scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [scrollView, stackView].disableAutoresizingMask()
        
        [scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
        
        [stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
         stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
         stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)].activate()
    }
}

