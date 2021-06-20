//
//  WeatherForecaseViewModel.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 18/06/2021.
//

import RxSwift
import RxCocoa

struct WeatherForecastViewData {
    struct DayForecast {
        let date: String
        let morningTemperature: String
        let dayTemperature: String
        let nightTemperature: String
    }
    let city: String
    let temperatureForecasts: [DayForecast]
}

protocol WeatherForecastViewModelInterface {
    var refreshData: PublishSubject<Void> { get }
    var output: Driver<WeatherForecastViewData> { get }
    var errors: Driver<Error> { get }
}

class WeatherForecastViewModel: WeatherForecastViewModelInterface {
    private let disposeBag = DisposeBag()
    private let service: WeatherServiceInterface
    private let outputRelay = PublishRelay<WeatherForecastViewData>()
    private let errorsRelay = PublishRelay<Error>()
    
    let refreshData: PublishSubject<Void> = .init()
    var output: Driver<WeatherForecastViewData> {
        outputRelay.asDriver(onErrorRecover: { _ in .empty() })
    }
    var errors: Driver<Error> {
        errorsRelay.asDriver(onErrorRecover: { _ in .empty() })
    }
    
    init(service: WeatherServiceInterface) {
        self.service = service
        
        setupBindings()
    }
    
    private func setupBindings() {
        let dataRequest = refreshData
            .append(weak: self)
            .flatMapLatest { vm, _ -> Observable<Event<FiveDaysForecastDto>> in
                vm.service.getFiveDaysForecast().materialize()
            }.share()
        
        dataRequest.elements()
            .map { forecastData in
                let temperatureForecasts = forecastData.groupByDay().map { data -> WeatherForecastViewData.DayForecast in
                    .init(date: String(data[0].dtTxt.split(separator: " ")[0]), morningTemperature: data.morningTemperature, dayTemperature: data.dayTemperature, nightTemperature: data.nightTemperature)
                }
                return WeatherForecastViewData(city: forecastData.city.name, temperatureForecasts: temperatureForecasts)
            }.bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        dataRequest.errors()
            .bind(to: errorsRelay)
            .disposed(by: disposeBag)
    }
}

private extension FiveDaysForecastDto {
    func groupByDay() -> [[List]] {
        let days = Array(Set(self.list.map { String($0.dtTxt.split(separator: " ")[0]) }))
        var forecasts: [[List]] = []
        days.forEach { day in
            forecasts.append(self.list.filter { $0.dtTxt.contains(day) }.sorted(by: { $0.dt < $1.dt }))
        }
        return forecasts.sorted(by: { $0[0].dt < $1[0].dt })
    }
}

private extension Array where Element == List {
    private enum DayPartConsts: String {
        case morningTime = "09:00:00"
        case dayTime = "15:00:00"
        case nightTime = "21:00:00"
    }
    private struct Values {
        static let unknown = "unknown"
        static let unit = "°C"
    }
    
    var morningTemperature: String {
        stringValueForTemperature(temperatureForecastFor(dayPart: .morningTime))
    }
    
    var dayTemperature: String {
        stringValueForTemperature(temperatureForecastFor(dayPart: .dayTime))
    }
    
    var nightTemperature: String {
        stringValueForTemperature(temperatureForecastFor(dayPart: .nightTime))
    }
    
    private func temperatureForecastFor(dayPart: DayPartConsts) -> Double? {
        self.first(where: { $0.dtTxt.contains(dayPart.rawValue) })?.main.temp
    }
    
    private func stringValueForTemperature(_ temperature: Double?) -> String {
        if let temperature = temperature {
            return String(temperature) + Values.unit
        } else {
            return Values.unknown
        }
    }
}
