//
//  UIManager.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit


class UIManager {
    
    static let shared = UIManager()
    
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
    
    //UI Elements
    var selectedImageView: UIImageView!
    var selectedNameLabel: UILabel!
    var textShadowLayer: UIView!
    
    
    //set up the user interface elements
    func setUpUI(forView view: UIView) {
        
        selectedImageView = UIImageView()
        selectedNameLabel = createLabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
        selectedNameLabel.textColor = UIColor.white
        
        // adds shadow on white text for selectedNameLabel
        textShadowLayer = UIView()
        textShadowLayer.layer.shadowColor = UIColor.black.cgColor
        textShadowLayer.layer.shadowOpacity = 0.9
        textShadowLayer.layer.shadowOffset = CGSize(width: 1, height: 1)
        textShadowLayer.layer.shadowRadius = 1
        
        view.addSubview(selectedImageView)
        selectedImageView.addSubview(textShadowLayer)
        textShadowLayer.addSubview(selectedNameLabel)
        
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        textShadowLayer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedImageView.heightAnchor.constraint(equalToConstant: 270),
            
            textShadowLayer.topAnchor.constraint(equalTo: selectedImageView.topAnchor, constant: 195),
            textShadowLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textShadowLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            selectedNameLabel.topAnchor.constraint(equalTo: selectedImageView.topAnchor, constant: 195),
            selectedNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            
        ])
    }
}
