//
//  HistoryCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    var trailHistoryLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        trailHistoryLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        
        // Add the trailHoursLabel to the cell's content view
        contentView.addSubview(trailHistoryLabel)
        
        // Configure constraints for trailHoursLabel
        NSLayoutConstraint.activate([
            trailHistoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            trailHistoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailHistoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            trailHistoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
