//
//  TableVIewManager.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class TableViewManager {
    
    static func configureTableView(for tableView: UITableView, withDelegate delegate: UITableViewDelegate & UITableViewDataSource) {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 320
        tableView.dataSource = delegate
        tableView.delegate = delegate
        tableView.separatorStyle = .none
    }
}

