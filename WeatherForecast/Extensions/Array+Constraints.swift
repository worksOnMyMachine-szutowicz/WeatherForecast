//
//  Array+Constraints.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 20/06/2021.
//

import UIKit

extension Array where Element: NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
}

extension Array where Element: UIView {
    func disableAutoresizingMask() {
        forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
