//
//  HoursCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class HoursCell: UITableViewCell {
    
    var trailHoursLabel: UILabel!
    var trailHolidayHours: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        trailHoursLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailHolidayHours = createLabel(font: UIFont.italicSystemFont(ofSize: 16))

        // Add the trailHoursLabel to the cell's content view
        contentView.addSubview(trailHoursLabel)
        contentView.addSubview(trailHolidayHours)

        // Configure constraints for trailHoursLabel
        NSLayoutConstraint.activate([
            trailHoursLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            trailHoursLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailHoursLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trailHolidayHours.topAnchor.constraint(equalTo: trailHoursLabel.bottomAnchor, constant: 20),
            trailHolidayHours.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailHolidayHours.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            trailHolidayHours.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
