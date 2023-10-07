//
//  HoursTableViewCell.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/20/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class HoursTableViewCell: UITableViewCell {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        // Configure your tableView...
        return tableView
    }()
    
    func createLabel(font: UIFont, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = font
        label.textAlignment = alignment
        return label
    }
    
    lazy var hoursLabel: UILabel = {
        createLabel(font: UIFont.systemFont(ofSize:15, weight: .regular), alignment: .left)
    }()
    
    lazy var descriptionLabel: UILabel = {
        createLabel(font: UIFont.systemFont(ofSize:15, weight: .regular), alignment: .left)
    }()
    
    
    
    lazy var myView: UIView = {
        let view = UIView()
        view.addSubview(hoursLabel)
        view.backgroundColor = .white
        return view
    }()
    
    
    var park: ParkData? {
        didSet {
            updateUI()
        }
    }
    private func updateUI() {
        guard let park = park,
            let operationHours = park.operatingHours,
            let firstOperatingHours = operationHours.first,
            let standardHours = firstOperatingHours.standardHours else { return }
        
        let sundayHours = standardHours.sunday
        let mondayHours = standardHours.monday
        let tuesdayHours = standardHours.tuesday
        let wednesdayHours = standardHours.wednesday
        let thursdayHours = standardHours.thursday
        let fridayHours = standardHours.friday
        let saturdayHours = standardHours.saturday
        
        let text = "\nSunday: \(sundayHours) \nMonday: \(mondayHours) \nTuesday: \(tuesdayHours) \nWednesday: \(wednesdayHours) \nThursday: \(thursdayHours) \nFriday: \(fridayHours) \nSaturday: \(saturdayHours)\n\n"
        
        hoursLabel.text = text
        hoursLabel.numberOfLines = 0 // Allow multiple lines
        hoursLabel.lineBreakMode = .byWordWrapping // Wrap text at word boundaries
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(tableView)
        contentView.addSubview(descriptionLabel)

        
        tableView.register(HoursTableViewCell.self, forCellReuseIdentifier: "hoursCell")
        contentView.addSubview(myView)
        setUpConstraints()
    }
    
    func setUpConstraints() {
        myView.translatesAutoresizingMaskIntoConstraints = false
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            myView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            hoursLabel.topAnchor.constraint(equalTo: myView.bottomAnchor, constant: 15),
            hoursLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hoursLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
          descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
          descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
          descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
            
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

