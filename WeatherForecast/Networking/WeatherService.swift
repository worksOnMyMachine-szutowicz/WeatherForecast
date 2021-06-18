//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 18/06/2021.
//

import Foundation
import RxSwift

protocol WeatherServiceInterface {
    func getFiveDaysForecast() -> Observable<FiveDaysForecastDto>
}

class WeatherService: WeatherServiceInterface {
    private let httpEngine: HttpEngineInterface
    
    init(httpEngine: HttpEngineInterface) {
        self.httpEngine = httpEngine
    }
    
    func getFiveDaysForecast() -> Observable<FiveDaysForecastDto> {
        return httpEngine.fetch(from: WeatherRequests.getFiveDaysForecast())
            .map { try JSONDecoder().decode(FiveDaysForecastDto.self, from: $0) }
    }
}
