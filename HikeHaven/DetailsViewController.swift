//
//  DetailsViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var selectedImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        title = "Trails"
        
        selectedImageView = UIImageView()
       // selectedImageView.contentMode = .scaleAspectFit
        view.addSubview(selectedImageView)
        
        setUpConstraints()
    }
    
    
    func setUpConstraints() {
       
       selectedImageView.translatesAutoresizingMaskIntoConstraints = false

       NSLayoutConstraint.activate([
    
           selectedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           selectedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           selectedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           selectedImageView.heightAnchor.constraint(equalToConstant: 270)
        ])
    }

}
