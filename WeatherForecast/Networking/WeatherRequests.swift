//
//  WeatherRequests.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 18/06/2021.
//

import Foundation

class WeatherRequests {
    private static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    private static let appId = "24eec778e01b76c3f4d4b71769cb4f1e"
    
    static func getFiveDaysForecast() -> URLRequest? {
        createRequest(method: "forecast", params: [.init(name: "q", value: "Gdansk"), .init(name: "units", value: "metric"), .init(name: "appId", value: appId)])
    }
    
    private static func createRequest(method: String, params: [Param]) -> URLRequest? {
        guard let url = URL(string: baseUrl + method + params.toString()) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

private struct Param {
    let name: String
    let value: String
}

private extension Array where Element == Param {
    func toString() -> String {
        var string = ""
        self.enumerated().forEach { index, param in
            string.appendParam(param, isFirst: index == 0)
        }
        return string
    }
}

private extension String {
    mutating func appendParam(_ param: Param, isFirst: Bool) {
        self.append("\(isFirst ? "?" : "&")\(param.name)=\(param.value)")
    }
}
