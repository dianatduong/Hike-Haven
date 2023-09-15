//
//  ContactsTableViewCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/14/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    func createLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = font
        label.textAlignment = .left
        return label
    }

      lazy var phoneNumber = createLabel(font: UIFont.boldSystemFont(ofSize: 16.5))
      lazy var emailAddress = createLabel(font: UIFont.systemFont(ofSize: 15))
           
        lazy var myView: UIView = {
           let view = UIView()
           view.addSubview(phoneNumber)
           view.addSubview(emailAddress)

           view.backgroundColor = .white
           return view
       }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        
            contentView.addSubview(myView)
            setUpConstraints()
    }
    
    func setUpConstraints() {
        myView.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        emailAddress.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            myView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),

            phoneNumber.topAnchor.constraint(equalTo: myView.topAnchor),
            phoneNumber.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 20),
            phoneNumber.trailingAnchor.constraint(equalTo: myView.trailingAnchor,constant: -20),

            emailAddress.topAnchor.constraint(equalTo: phoneNumber.topAnchor, constant: 10),
            emailAddress.leadingAnchor.constraint(equalTo: myView.leadingAnchor,constant: 20),
            emailAddress.trailingAnchor.constraint(equalTo: myView.trailingAnchor,constant: -20)
        ])
    }
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    






}
