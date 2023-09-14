//
//  MainTableViewCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    var mainImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.layer.cornerRadius = 10.0
      imageView.layer.masksToBounds = true
      imageView.isUserInteractionEnabled = true
      return imageView
    }()

    var shadowView: UIView = {
      let view = UIView()
      view.layer.shadowColor = UIColor.black.cgColor
      view.layer.shadowOpacity = 0.6
      view.layer.shadowOffset = CGSize(width: 1, height: 1)
      view.layer.shadowRadius = 1
      return view
    }()
    
    private static func createLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = font
        label.textAlignment = .left
        return label
    }

    var nameLabel = createLabel(font: UIFont.boldSystemFont(ofSize: 16.5))
    var addressLabel = createLabel(font: UIFont.systemFont(ofSize: 15))
    var cityLabel = createLabel(font: UIFont.systemFont(ofSize: 15))
    var stateLabel = createLabel(font: UIFont.systemFont(ofSize: 15))
    var postCodeLabel = createLabel(font: UIFont.systemFont(ofSize: 15))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(shadowView)
        shadowView.addSubview(mainImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(stateLabel)
        contentView.addSubview(postCodeLabel)
        setUpConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        postCodeLabel.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 15),
            mainImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -15),
            mainImageView.heightAnchor.constraint(equalToConstant: 225),
            
            nameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cityLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 1.5),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stateLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 1.5),
            stateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            postCodeLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 1.5),
            postCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            postCodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

}
