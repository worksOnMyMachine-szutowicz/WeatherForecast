//
//  Factory.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 18/06/2021.
//

import UIKit

class AppFactory {
    private let httpEngine: HttpEngineInterface
    private let weatherService: WeatherServiceInterface
    
    init() {
        httpEngine = HttpEngine()
        weatherService = WeatherService(httpEngine: httpEngine)
    }
    
    func createWeatherForecastViewController() -> UIViewController {
        let viewModel = WeatherForecastViewModel(service: weatherService)
        return WeatherForecastViewController(viewModel: viewModel)
    }
}
