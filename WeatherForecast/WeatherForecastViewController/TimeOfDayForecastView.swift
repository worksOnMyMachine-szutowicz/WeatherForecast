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
    private let tempTitleLabel = UILabel()
    private let tempValueLabel = UILabel()
    private let humTitleLabel = UILabel()
    private let humValueLabel = UILabel()
    
    init(timeOfDay: TimeOfDay, forecast: WeatherForecastViewData.DayForecast.TimeOfDayForecast) {
        super.init(frame: .zero)
        
        titleLabel.text = timeOfDay.rawValue
        tempTitleLabel.text = "Temp:"
        tempTitleLabel.font = .systemFont(ofSize: 10)
        tempValueLabel.text = forecast.temperature
        humTitleLabel.text = "Hum:"
        humTitleLabel.font = .systemFont(ofSize: 10)
        humValueLabel.text = forecast.humidity
        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray.cgColor
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        let tempContainer = UIView()
        let humContainer = UIView()
        addSubview(titleLabel)
        addSubview(tempContainer)
        addSubview(humContainer)
        tempContainer.addSubview(tempTitleLabel)
        tempContainer.addSubview(tempValueLabel)
        humContainer.addSubview(humTitleLabel)
        humContainer.addSubview(humValueLabel)
        [tempContainer, humContainer, titleLabel, tempTitleLabel, tempValueLabel, humTitleLabel, humValueLabel].disableAutoresizingMask()
        
        widthAnchor.constraint(equalToConstant: Values.viewWidth).isActive = true
        
        [titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Values.padding)].activate()
        
        [tempContainer.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
         tempContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)].activate()
        
        [tempTitleLabel.leadingAnchor.constraint(equalTo: tempContainer.leadingAnchor),
         tempTitleLabel.centerYAnchor.constraint(equalTo: tempContainer.centerYAnchor)].activate()
        [tempValueLabel.leadingAnchor.constraint(equalTo: tempTitleLabel.trailingAnchor, constant: Values.padding),
         tempValueLabel.trailingAnchor.constraint(equalTo: tempContainer.trailingAnchor),
         tempValueLabel.topAnchor.constraint(equalTo: tempContainer.topAnchor),
         tempValueLabel.bottomAnchor.constraint(equalTo: tempContainer.bottomAnchor)].activate()
        
        [humContainer.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
         humContainer.topAnchor.constraint(equalTo: tempContainer.bottomAnchor),
         humContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Values.padding)].activate()
        
        [humTitleLabel.leadingAnchor.constraint(equalTo: humContainer.leadingAnchor),
         humTitleLabel.centerYAnchor.constraint(equalTo: humContainer.centerYAnchor)].activate()
        [humValueLabel.leadingAnchor.constraint(equalTo: humTitleLabel.trailingAnchor, constant: Values.padding),
         humValueLabel.trailingAnchor.constraint(equalTo: humContainer.trailingAnchor),
         humValueLabel.topAnchor.constraint(equalTo: humContainer.topAnchor),
         humValueLabel.bottomAnchor.constraint(equalTo: humContainer.bottomAnchor)].activate()
    }
}
