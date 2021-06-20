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
        struct TimeOfDayForecast {
            let temperature: String
            let humidity: String
        }
        let date: String
        let morning: TimeOfDayForecast
        let day: TimeOfDayForecast
        let night: TimeOfDayForecast
    }
    struct Stats {
        let maxTemperature: (dateTime: String, value: String)
        let minTemperature: (dateTime: String, value: String)
        let meanTemperature: String
        let modeTemperature: String
    }
    let city: String
    let dayForecasts: [DayForecast]
    let stats: Stats
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
                let dayForecasts = forecastData.groupByDay().map { data -> WeatherForecastViewData.DayForecast in
                    let date = String(data[0].dtTxt.split(separator: " ")[0])
                    let morningForecast = WeatherForecastViewData.DayForecast.TimeOfDayForecast(temperature: data.morningTemperature, humidity: data.morningHumidity)
                    let dayForecast = WeatherForecastViewData.DayForecast.TimeOfDayForecast(temperature: data.dayTemperature, humidity: data.dayHumidity)
                    let nightForecast = WeatherForecastViewData.DayForecast.TimeOfDayForecast(temperature: data.nightTemperature, humidity: data.nightHumidity)
                    return .init(date: date, morning: morningForecast, day: dayForecast, night: nightForecast)
                }
                let stats = WeatherForecastViewData.Stats(maxTemperature: forecastData.list.maxTemperature,
                                                          minTemperature: forecastData.list.minTemperature,
                                                          meanTemperature: forecastData.list.meanTemperature,
                                                          modeTemperature: forecastData.list.modeTemperature)
                return WeatherForecastViewData(city: forecastData.city.name, dayForecasts: dayForecasts, stats: stats)
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
        static let unknown = "-"
        static let temperatureUnit = "°C"
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
    
    var maxTemperature: (dateTime: String, value: String) {
        let record = self.sorted(by: { $0.main.temp > $1.main.temp }).first
        return dateTimeValueTemperature(for: record)
    }
    
    var minTemperature: (dateTime: String, value: String) {
        let record = self.sorted(by: { $0.main.temp < $1.main.temp }).first
        return dateTimeValueTemperature(for: record)
    }
    
    var meanTemperature: String {
        String(format: "%.2f", self.map { $0.main.temp }.reduce(0, +)/Double(count))
    }
    
    var modeTemperature: String {
        let temperatures = self.map { round($0.main.temp) }
        let occurences = temperatures.reduce(into: [:]) { $0[$1, default: 0] += 1 }.sorted(by: { $0.value > $1.value })
        return stringValueForTemperature(occurences.first?.0)
    }
    
    var morningHumidity: String {
        stringValueForHumidity(humidityForecastFor(dayPart: .morningTime))
    }
    
    var dayHumidity: String {
        stringValueForHumidity(humidityForecastFor(dayPart: .dayTime))
    }
    
    var nightHumidity: String {
        stringValueForHumidity(humidityForecastFor(dayPart: .nightTime))
    }
    
    private func temperatureForecastFor(dayPart: DayPartConsts) -> Double? {
        self.first(where: { $0.dtTxt.contains(dayPart.rawValue) })?.main.temp
    }
    
    private func humidityForecastFor(dayPart: DayPartConsts) -> Int? {
        self.first(where: { $0.dtTxt.contains(dayPart.rawValue) })?.main.humidity
    }
    
    private func stringValueForTemperature(_ temperature: Double?) -> String {
        if let temperature = temperature {
            return String(temperature) + Values.temperatureUnit
        } else {
            return Values.unknown
        }
    }
    
    private func stringValueForHumidity(_ humidity: Int?) -> String {
        if let humidity = humidity {
            return String(humidity)
        } else {
            return Values.unknown
        }
    }
    
    private func dateTimeValueTemperature(for record: List?) -> (dateTime: String, value: String) {
        guard let record = record else {
            return (Values.unknown, Values.unknown)
        }
        return (record.dtTxt, stringValueForTemperature(record.main.temp))
    }
}
