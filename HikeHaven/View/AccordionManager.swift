//
//  AccordionManager.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/15/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class AccordionManager: UITableViewController {
    
    static let shared = AccordionManager()
    
    let accordionTableView: UITableView = UITableView()
    
    
    init() {
        super.init(style: .plain)
    }
    
    
    func setUpAccordion(forView view: UIView) {
        
        view.addSubview(accordionTableView)
        
        accordionTableView.translatesAutoresizingMaskIntoConstraints = false
        accordionTableView.separatorStyle = .none
        accordionTableView.rowHeight = UITableView.automaticDimension // dynamic row height
        
        accordionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        accordionTableView.register(ContactsCell.self, forCellReuseIdentifier: "contactsCell")
        accordionTableView.register(DirectionsCell.self, forCellReuseIdentifier: "directionsCell")
        accordionTableView.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        accordionTableView.register(HoursCell.self, forCellReuseIdentifier: "hoursCell")
        accordionTableView.register(WeatherCell.self, forCellReuseIdentifier: "weatherCell")
        
        NSLayoutConstraint.activate([
            accordionTableView.topAnchor.constraint(equalTo: UIManager.shared.selectedImageView.bottomAnchor),
            accordionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accordionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accordionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
