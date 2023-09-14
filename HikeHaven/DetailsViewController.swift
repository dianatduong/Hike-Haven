//
//  DetailsViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let accordionVC = AccordionViewController()

    var selectedImageView: UIImageView!
    
    lazy var selectedNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.white
    return label
    }()
    
    func createLabel(font: UIFont) -> UILabel {
         let label = UILabel()
         label.numberOfLines = 0
         label.adjustsFontSizeToFitWidth = true
         label.font = font
         label.textAlignment = .left
         return label
     }
    
    lazy var trailAddressLabel = createLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold))
    lazy var trailCityLabel = createLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold))
    lazy var trailStateLabel = createLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold))
    lazy var trailZipCodeLabel = createLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold))
    lazy var trailDescriptionLabel = createLabel(font: UIFont.systemFont(ofSize: 16))
    
    lazy var trailInfoContainerView: UIView = {
        let view = UIView()
        view.addSubview(trailAddressLabel)
        view.addSubview(trailCityLabel)
        view.addSubview(trailStateLabel)
        view.addSubview(trailZipCodeLabel)
        view.addSubview(trailDescriptionLabel)
        return view
    }()
    
   lazy var backgroundView: UIView = {
         let view = UIView()
         view.layer.shadowColor = UIColor.black.cgColor
         view.layer.shadowOpacity = 0.8
         view.layer.shadowOffset = CGSize(width: 1, height: 1)
         view.layer.shadowRadius = 1
          view.addSubview(selectedNameLabel)
         return view
    }()
    
    let name = " "
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        title = "Trails"
        
        selectedImageView = UIImageView()
        selectedNameLabel.text = name
        view.addSubview(selectedImageView)
        selectedImageView.addSubview(backgroundView)
        view.addSubview(trailInfoContainerView)
        view.addSubview(accordionVC.view)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        trailInfoContainerView.translatesAutoresizingMaskIntoConstraints = false
        trailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        trailCityLabel.translatesAutoresizingMaskIntoConstraints = false
        trailStateLabel.translatesAutoresizingMaskIntoConstraints = false
        trailZipCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        trailDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        accordionVC.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedImageView.heightAnchor.constraint(equalToConstant: 270),

            backgroundView.topAnchor.constraint(equalTo: selectedImageView.topAnchor, constant: 195),
                    backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                    backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
         selectedNameLabel.topAnchor.constraint(equalTo: selectedImageView.topAnchor, constant: 195),
                             selectedNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                             selectedNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            trailInfoContainerView.topAnchor.constraint(equalTo: selectedImageView.bottomAnchor, constant: 5),
            trailInfoContainerView.widthAnchor.constraint(equalToConstant: 420),

            trailAddressLabel.topAnchor.constraint(equalTo: trailInfoContainerView.topAnchor, constant: 10),
            trailAddressLabel.leadingAnchor.constraint(equalTo: trailInfoContainerView.leadingAnchor, constant: 15),
            trailAddressLabel.trailingAnchor.constraint(equalTo: trailInfoContainerView.trailingAnchor, constant: -15),
            trailCityLabel.topAnchor.constraint(equalTo: trailAddressLabel.bottomAnchor, constant: 2),
            trailCityLabel.leadingAnchor.constraint(equalTo: trailInfoContainerView.leadingAnchor, constant: 15),
            trailStateLabel.topAnchor.constraint(equalTo: trailAddressLabel.bottomAnchor, constant: 2),
            trailStateLabel.leadingAnchor.constraint(equalTo: trailCityLabel.trailingAnchor),
            trailZipCodeLabel.topAnchor.constraint(equalTo: trailAddressLabel.bottomAnchor, constant: 2),
            trailZipCodeLabel.leadingAnchor.constraint(equalTo: trailStateLabel.trailingAnchor),

            trailDescriptionLabel.topAnchor.constraint(equalTo: trailCityLabel.bottomAnchor, constant: 8),
            trailDescriptionLabel.leadingAnchor.constraint(equalTo: trailInfoContainerView.leadingAnchor, constant: 15),
            trailDescriptionLabel.trailingAnchor.constraint(equalTo: trailInfoContainerView.trailingAnchor, constant: -20),

            accordionVC.view.topAnchor.constraint(equalTo: trailDescriptionLabel.bottomAnchor, constant: 15),
            accordionVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accordionVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accordionVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    init() {
           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
}
