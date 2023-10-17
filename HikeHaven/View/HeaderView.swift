//
//  HeaderView.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    static let shared = HeaderView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stateCodePicker = UIPickerView()



    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        

         
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    func setupSubviews() {
        addSubview(titleLabel)
        addSubview(stateCodePicker)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stateCodePicker.translatesAutoresizingMaskIntoConstraints = false
        stateCodePicker.isUserInteractionEnabled = true


       NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            stateCodePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -80),
            stateCodePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            stateCodePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stateCodePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            //stateCodePicker.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
 
}

