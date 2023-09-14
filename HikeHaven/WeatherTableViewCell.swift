//
//  WeatherTableViewCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/14/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6.0
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    func createLabel(font: UIFont, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = font
        label.textAlignment = alignment
        return label
    }

    lazy var weatherLabel: UILabel = {
        createLabel(font: UIFont.systemFont(ofSize:15, weight: .regular), alignment: .left)
    }()

    lazy var tempLabel: UILabel = {
        createLabel(font: UIFont.systemFont(ofSize:35, weight: .semibold), alignment: .center)
    }()


    lazy var myView: UIView = {
        let view = UIView()
        view.addSubview(weatherIcon)
        view.addSubview(tempLabel)
        view.addSubview(weatherLabel)

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
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            myView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),

            weatherIcon.topAnchor.constraint(equalTo: myView.topAnchor),
            weatherIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 90),
            weatherIcon.heightAnchor.constraint(equalToConstant: 70),

            tempLabel.topAnchor.constraint(equalTo: myView.topAnchor, constant: 10),
            tempLabel.leadingAnchor.constraint(equalTo: weatherIcon.leadingAnchor,constant: 105),
            tempLabel.bottomAnchor.constraint(equalTo: weatherLabel.topAnchor, constant: -20),

            weatherLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 15),
            weatherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weatherLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)

        ])
    }
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}




