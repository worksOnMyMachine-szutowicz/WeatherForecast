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
        static let spacing: CGFloat = 5
    }
    private let dateLabel = UILabel()
    private let stackView = UIStackView()
    
    init(viewData: WeatherForecastViewData.DayForecast) {
        super.init(frame: .zero)
        
        dateLabel.text = "Forecast for \(viewData.date)"
        dateLabel.font = .boldSystemFont(ofSize: 20)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = Values.spacing
        stackView.addArrangedSubview(TimeOfDayForecastView(timeOfDay: .morning, forecast: viewData.morning))
        stackView.addArrangedSubview(TimeOfDayForecastView(timeOfDay: .day, forecast: viewData.day))
        stackView.addArrangedSubview(TimeOfDayForecastView(timeOfDay: .night, forecast: viewData.night))
        
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
         stackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Values.padding),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
}
