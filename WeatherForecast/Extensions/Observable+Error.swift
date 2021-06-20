//
//  Observable+Error.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 20/06/2021.
//

import RxSwift

extension ObservableType where Element: EventConvertible {
    func elements() -> Observable<Element.Element> {
        filter { $0.event.element != nil }.map { $0.event.element! }
    }
    
    func errors() -> Observable<Swift.Error> {
        filter { $0.event.error != nil }.map { $0.event.error! }
    }
}
