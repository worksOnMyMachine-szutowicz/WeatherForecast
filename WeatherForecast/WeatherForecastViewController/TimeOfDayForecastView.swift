//
//  TimeOfDayForecastView.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 20/06/2021.
//

import UIKit
import Lottie

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
    private var animationView: AnimationView
    private let temperatureRow: TitleValueLabelsRowView
    private let humidityRow: TitleValueLabelsRowView
    
    init(timeOfDay: TimeOfDay, forecast: WeatherForecastViewData.DayForecast.TimeOfDayForecast) {
        let skyStatusAnimation = forecast.skyStatus?.animationName ?? "unknown"
        animationView = .init(name: skyStatusAnimation)
        temperatureRow = .init(title: "Temp:", value: forecast.temperature)
        humidityRow = .init(title: "Hum:", value: forecast.humidity)
        
        super.init(frame: .zero)
        
        titleLabel.text = timeOfDay.rawValue
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
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
        addSubview(animationView)
        addSubview(titleLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(temperatureRow)
        stackView.addArrangedSubview(humidityRow)
        [titleLabel, animationView, stackView].disableAutoresizingMask()
        
        widthAnchor.constraint(equalToConstant: Values.viewWidth).isActive = true
        
        [titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Values.padding)].activate()
        
        [animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
         animationView.widthAnchor.constraint(equalToConstant: Values.viewWidth - 2 * Values.padding),
         animationView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         animationView.heightAnchor.constraint(equalToConstant: Values.viewWidth - 2 * Values.padding)].activate()

        [stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
         stackView.topAnchor.constraint(equalTo: animationView.bottomAnchor),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Values.padding)].activate()
    }
}

private extension SkyStatus {
    var animationName: String {
        switch self {
        case .clear:
            return "sunny"
        case .clouds:
            return "clouds"
        case .rain:
            return "rain"
        }
    }
}
