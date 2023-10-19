//
//  HistoryCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    lazy var trailHistoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.font =  UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        // Add the trailHoursLabel to the cell's content view
        contentView.addSubview(trailHistoryLabel)
        
        // Configure constraints for trailHoursLabel
        NSLayoutConstraint.activate([
            trailHistoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            trailHistoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailHistoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            trailHistoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
