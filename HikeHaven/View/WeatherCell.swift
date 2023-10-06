//
//  WeatherCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    var weatherLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        weatherLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))

        contentView.addSubview(weatherLabel)
        
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            weatherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weatherLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            weatherLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
