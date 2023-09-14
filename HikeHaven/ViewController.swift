//
//  ViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Popular Trails"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerView = UIView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Hike Haven"
        setUpHeader()
        
        
    }

    func setUpHeader() {
        headerView.addSubview(headerTitle)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = 60
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12),
            headerTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20)
        ])
    }
    
    //fetching API
    let dispatchGroup = DispatchGroup()

    func fetchAllData() {
        dispatchGroup.enter()
        fetchImagesAPI()
        
        dispatchGroup.enter()
        fetchDataAPI()
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

   


}

