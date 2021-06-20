//
//  DayForecastView.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 20/06/2021.
//

import UIKit

class DayForecastView: UIView {
    private struct Values {
        static let padding: CGFloat = 20
        static let spacing: CGFloat = 10
    }
    private let dateLabel = UILabel()
    private let stackView = UIStackView()
    
    init(viewData: WeatherForecastViewData.DayForecast) {
        super.init(frame: .zero)
        
        dateLabel.text = viewData.date
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Values.spacing
        stackView.addArrangedSubview(TimeOfDayForecastView(timeOfDay: .morning, temperature: viewData.morningTemperature))
        stackView.addArrangedSubview(TimeOfDayForecastView(timeOfDay: .day, temperature: viewData.dayTemperature))
        stackView.addArrangedSubview(TimeOfDayForecastView(timeOfDay: .night, temperature: viewData.nightTemperature))
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func layout() {
        addSubview(dateLabel)
        addSubview(stackView)
        [dateLabel, stackView].disableAutoresizingMask()
        
        [dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Values.padding),
         dateLabel.topAnchor.constraint(equalTo: topAnchor)].activate()
        [stackView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Values.padding),
         stackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
}
