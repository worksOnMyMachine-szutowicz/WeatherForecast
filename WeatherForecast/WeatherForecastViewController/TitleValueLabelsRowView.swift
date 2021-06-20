//
//  TitleValueLabelsRowView.swift
//  WeatherForecast
//
//  Created by Krystian Szutowicz-EXT on 20/06/2021.
//

import UIKit

class TitleValueLabelsRowView: UIView {
    private struct Values {
        static let padding: CGFloat = 5
    }
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    init(title: String, value: String) {
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 10)
        valueLabel.text = value
        
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        [titleLabel, valueLabel].disableAutoresizingMask()
        
        [titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Values.padding),
         titleLabel.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor)].activate()
        [valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Values.padding),
         valueLabel.topAnchor.constraint(equalTo: topAnchor),
         valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
}
