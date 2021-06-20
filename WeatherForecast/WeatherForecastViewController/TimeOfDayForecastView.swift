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
        static let viewWidth: CGFloat = 110
    }
    enum TimeOfDay: String  {
        case morning = "Morning"
        case day = "Day"
        case night = "Night"
    }
    private let titleLabel = UILabel()
    private let temperatureRow: TitleValueLabelsRowView
    private let humidityRow: TitleValueLabelsRowView
    
    init(timeOfDay: TimeOfDay, forecast: WeatherForecastViewData.DayForecast.TimeOfDayForecast) {
        temperatureRow = .init(title: "Temp:", value: forecast.temperature)
        humidityRow = .init(title: "Hum:", value: forecast.humidity)
        
        super.init(frame: .zero)
        
        titleLabel.text = timeOfDay.rawValue
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        addSubview(titleLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(temperatureRow)
        stackView.addArrangedSubview(humidityRow)
        [titleLabel, stackView].disableAutoresizingMask()
        
        widthAnchor.constraint(equalToConstant: Values.viewWidth).isActive = true
        
        [titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Values.padding)].activate()
        [stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
         stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Values.padding)].activate()
    }
}
