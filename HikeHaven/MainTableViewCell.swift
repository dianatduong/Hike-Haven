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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(shadowView)
        shadowView.addSubview(mainImageView)
        setUpConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            mainImageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 15),
            mainImageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -15),
            mainImageView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

}
