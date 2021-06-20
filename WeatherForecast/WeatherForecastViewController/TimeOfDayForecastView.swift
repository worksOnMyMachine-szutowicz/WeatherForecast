//
//  TimeOfDayForecastView.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 20/06/2021.
//

import UIKit

class TimeOfDayForecastView: UIView {
    private struct Values {
        static let padding: CGFloat = 5
    }
    enum TimeOfDay: String  {
        case morning = "Morning"
        case day = "Day"
        case night = "Night"
    }
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    init(timeOfDay: TimeOfDay, temperature: String) {
        super.init(frame: .zero)
        
        titleLabel.text = timeOfDay.rawValue
        valueLabel.text = temperature
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        [titleLabel, valueLabel].disableAutoresizingMask()
        
        [titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         titleLabel.topAnchor.constraint(equalTo: topAnchor)].activate()
        [valueLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
         valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
}
