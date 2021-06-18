//
//  WeatherForecaseViewModel.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 18/06/2021.
//

import RxSwift

class WeatherForecastViewModel {
    private let disposeBag = DisposeBag()
    private let service: WeatherServiceInterface
    
    init(service: WeatherServiceInterface) {
        self.service = service
        
        setupBindings()
    }
    
    private func setupBindings() {
        service.getFiveDaysForecast()
            .subscribe {
                print($0)
            }.disposed(by: disposeBag)
    }
}
