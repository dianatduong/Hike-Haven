//
//  DirectionsCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class DirectionsCell: UITableViewCell {
    
    func createLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.font = font
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    var trailNameLabel: UILabel!
    var trailAddressLabel: UILabel!
    var trailCityLabel: UILabel!
    var trailStateLabel: UILabel!
    var trailZipCodeLabel: UILabel!
    var trailDirectionsInfoLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        trailNameLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailAddressLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailCityLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailStateLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailZipCodeLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailDirectionsInfoLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailDirectionsInfoLabel.isUserInteractionEnabled = true
        
        contentView.addSubview(trailNameLabel)
        contentView.addSubview(trailAddressLabel)
        contentView.addSubview(trailCityLabel)
        contentView.addSubview(trailStateLabel)
        contentView.addSubview(trailZipCodeLabel)
        contentView.addSubview(trailDirectionsInfoLabel)
        
        NSLayoutConstraint.activate([
            trailNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            trailNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trailAddressLabel.topAnchor.constraint(equalTo: trailNameLabel.bottomAnchor, constant: 4),
            trailAddressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trailDirectionsInfoLabel.topAnchor.constraint(equalTo: trailAddressLabel.bottomAnchor, constant: 15),
            trailDirectionsInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailDirectionsInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            trailDirectionsInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)

        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
