//
//  ForecastStatsView.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 20/06/2021.
//

import UIKit

class ForecastStatsView: UIView {
    private struct Values {
        static let padding: CGFloat = 5
    }
    private let titleLabel = UILabel()
    private let maxTemperatureRow: TitleValueLabelsRowView
    private let minTemperatureRow: TitleValueLabelsRowView
    private let meanTemperatureRow: TitleValueLabelsRowView
    private let modeTemperatureRow: TitleValueLabelsRowView
    
    init(stats: WeatherForecastViewData.Stats) {
        maxTemperatureRow = .init(title: "Max temperature:", value: "\(stats.maxTemperature.value) at \(stats.maxTemperature.dateTime)")
        minTemperatureRow = .init(title: "Min temperature:", value: "\(stats.minTemperature.value) at \(stats.minTemperature.dateTime)")
        meanTemperatureRow = .init(title: "Mean temperature", value: stats.meanTemperature)
        modeTemperatureRow = .init(title: "Mode temperature", value: stats.modeTemperature)
        
        super.init(frame: .zero)
        
        titleLabel.text = "Forecast Stats"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
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
        stackView.addArrangedSubview(maxTemperatureRow)
        stackView.addArrangedSubview(minTemperatureRow)
        stackView.addArrangedSubview(meanTemperatureRow)
        stackView.addArrangedSubview(modeTemperatureRow)
        [titleLabel, stackView].disableAutoresizingMask()
        
        [titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Values.padding)].activate()
        [stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
         stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Values.padding)].activate()
    }
}
