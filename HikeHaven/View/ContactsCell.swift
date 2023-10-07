//
//  ContactsCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class ContactsCell: UITableViewCell {
    
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
    
    
    var phoneNumberLabel: UILabel!
    var emailAddressLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        phoneNumberLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        emailAddressLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))

        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(emailAddressLabel)
   
        NSLayoutConstraint.activate([
            phoneNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            emailAddressLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 15),
            emailAddressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            emailAddressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)

        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
