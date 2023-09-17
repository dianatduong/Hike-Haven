

//
//  DetailsViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    let vc = ViewController()
    var accordionVC = AccordionViewController()
    
    //passed data from VC
    var selectedPark: ParkData?
    var selectedUnsplashData: UnSplashData?
    
    //UI Elements
    var selectedImageView: UIImageView!
    var selectedNameLabel: UILabel!
    var textShadowLayer: UIView!
    var trailInfoContainerView: UIView!
    var trailAddressLabel: UILabel!
    var trailCityLabel: UILabel!
    var trailStateLabel: UILabel!
    var trailZipCodeLabel: UILabel!
    var trailDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        title = "Trail"
    
        setUpUI()
        getData()
    }
    
    
    //used to populate the UI elements with data received from ViewController
    func getData() {
        // Update labels with the park data
        if let park = selectedPark, let unsplashData = selectedUnsplashData {
            selectedNameLabel.text = park.fullName
            trailDescriptionLabel.text = park.description
            
            // Load and display the image via loadImage function from vc
            if let imageURLString = unsplashData.urls.regular,
                let imageURL = URL(string: imageURLString) {
                vc.loadImage(from: imageURL) { image in
                    DispatchQueue.main.async {
                        self.selectedImageView.image = image
                    }
                }
            }
        }
        
        //unwrap [Addresses]
        if let park = selectedPark, let addresses = park.addresses, !addresses.isEmpty {
            if let firstAddress = addresses.first {
                let address = "\(firstAddress.line1)"
                let city = "\(firstAddress.city), "
                let state =  "\(firstAddress.stateCode) "
                let postalCode = "\(firstAddress.postalCode)"
                
                trailAddressLabel.text = address
                trailCityLabel.text = city
                trailStateLabel.text = state
                trailZipCodeLabel.text = postalCode
            }
        } else {
            // Handle the case where park.addresses is nil or empty
            trailAddressLabel.text = "Address not available"
            trailCityLabel.text = "City not available"
            trailStateLabel.text = "State not available"
            trailZipCodeLabel.text = "Postal code not available"
        }
        
    }
    
    //set up the user interface elements
    func setUpUI() {
        selectedImageView = UIImageView()
        selectedNameLabel = createLabel(font: UIFont.systemFont(ofSize: 25, weight: .bold))
        selectedNameLabel.textColor = UIColor.white
        
        // adds shadow on white text for selectedNameLabel
        textShadowLayer = UIView()
        textShadowLayer.layer.shadowColor = UIColor.black.cgColor
        textShadowLayer.layer.shadowOpacity = 0.9
        textShadowLayer.layer.shadowOffset = CGSize(width: 1, height: 1)
        textShadowLayer.layer.shadowRadius = 1
        
        //trailInfoContainer holds the address and description
        trailInfoContainerView = UIView()
        trailAddressLabel = createLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold))
        trailCityLabel = createLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold))
        trailStateLabel = createLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold))
        trailZipCodeLabel = createLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold))
        trailDescriptionLabel = createLabel(font: UIFont.systemFont(ofSize: 16))
        
        trailInfoContainerView.addSubview(trailAddressLabel)
        trailInfoContainerView.addSubview(trailCityLabel)
        trailInfoContainerView.addSubview(trailStateLabel)
        trailInfoContainerView.addSubview(trailZipCodeLabel)
        trailInfoContainerView.addSubview(trailDescriptionLabel)
        
        view.addSubview(trailInfoContainerView)
        view.addSubview(selectedImageView)
        selectedImageView.addSubview(textShadowLayer)
        view.addSubview(trailInfoContainerView)
        view.addSubview(accordionVC.view)
        
        setUpConstraints()
    }
    
    //a utility function to create UILabel instances with specific font settings
    func createLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = font
        label.textAlignment = .left
        return label
    }
    
    //sets up Auto Layout constraints to define the layout of UI elements
    func setUpConstraints() {
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        textShadowLayer.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            textShadowLayer.topAnchor.constraint(equalTo: selectedImageView.topAnchor, constant: 195),
            textShadowLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textShadowLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
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
            
            trailDescriptionLabel.topAnchor.constraint(equalTo: trailCityLabel.bottomAnchor, constant: 12),
            trailDescriptionLabel.leadingAnchor.constraint(equalTo: trailInfoContainerView.leadingAnchor, constant: 15),
            trailDescriptionLabel.trailingAnchor.constraint(equalTo: trailInfoContainerView.trailingAnchor, constant: -20),
            
            accordionVC.view.topAnchor.constraint(equalTo: trailDescriptionLabel.bottomAnchor, constant: 25),
            accordionVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accordionVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accordionVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
