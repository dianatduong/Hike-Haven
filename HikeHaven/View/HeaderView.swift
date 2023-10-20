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
        label.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        //label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stateCodePicker = UIPickerView()
    let textField = UITextField()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    

    }
    
    
    
    func setupSubviews() {
        addSubview(titleLabel)
        addSubview(textField)
        textField.inputView = stateCodePicker
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
      
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textField.borderStyle = .roundedRect

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        
        stateCodePicker.translatesAutoresizingMaskIntoConstraints = false
        stateCodePicker.isUserInteractionEnabled = true
        

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           
       }
}
