//
//  AppCoordinator.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 18/06/2021.
//

import UIKit

class AppCoordinator {
    private let navigationController: UINavigationController
    private let appFactory: AppFactory

    init(navigationController: UINavigationController, appFactory: AppFactory) {
        self.navigationController = navigationController
        self.appFactory = appFactory
    }

    func start() {
        navigationController.setViewControllers([appFactory.createWeatherForecastViewController()], animated: true)
    }
}
