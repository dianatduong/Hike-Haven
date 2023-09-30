

//
//  DetailsViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit


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


class DetailsViewController: UIViewController {
    
    let vc = ViewController()

    //API
    var accordionData: [OperatingHours] = []
    var weatherArray: [Periods] = []
    var parksArray: [ParkData] = []
    
    //Accordion Data
    var sections: [String] = ["Direction", "Park Hours", "Weather", "Contacts", "History"]
    var collapsed: [Bool] = [true, true, true, true, true]
    
    //passed data from VC
    var selectedPark: ParkData?   //property to hold the selected park
    var selectedUnsplashData: UnSplashData?
    var selectedWeatherData: Periods?
    
    //UI Elements
    var selectedImageView: UIImageView!
    var selectedNameLabel: UILabel!
    var textShadowLayer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpUI()
        getData()
        setUpAccordionTableView()
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
        
        view.addSubview(selectedImageView)
        selectedImageView.addSubview(textShadowLayer)
        textShadowLayer.addSubview(selectedNameLabel)
        
        setUpConstraints()
    }
    
    
    //sets up Auto Layout constraints to define the layout of UI elements
    func setUpConstraints() {
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        textShadowLayer.translatesAutoresizingMaskIntoConstraints = false
        
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
            
        ])
    }
    
    //UITableView for the accordion-style view
    func setUpAccordionTableView() {
        let accordionTableView = UITableView()
        accordionTableView.translatesAutoresizingMaskIntoConstraints = false
        accordionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        accordionTableView.register(DirectionsCell.self, forCellReuseIdentifier: "directionsCell")
        accordionTableView.register(HoursCell.self, forCellReuseIdentifier: "hoursCell")
        accordionTableView.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        
        
        accordionTableView.dataSource = self
        accordionTableView.delegate = self
        accordionTableView.separatorStyle = .none
        accordionTableView.estimatedRowHeight = 100 // Set an estimated row height
        accordionTableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(accordionTableView)
        
        NSLayoutConstraint.activate([
            accordionTableView.topAnchor.constraint(equalTo: selectedImageView.bottomAnchor, constant: 5),
            accordionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accordionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accordionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    //used to populate the UI elements with data received from ViewController
    func getData() {
        // Update labels with the park data
        if let park = selectedPark, let unsplashData = selectedUnsplashData {
            
            //Park Name
            selectedNameLabel.text = park.fullName
            navigationItem.largeTitleDisplayMode = .never
            title = park.fullName
            
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
    }
    
}

class DirectionsCell: UITableViewCell {
    
    var trailAddressLabel: UILabel!
    var trailCityLabel: UILabel!
    var trailStateLabel: UILabel!
    var trailZipCodeLabel: UILabel!
    var trailDirectionsInfoLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        trailAddressLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailCityLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailStateLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailZipCodeLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailDirectionsInfoLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        
        contentView.addSubview(trailAddressLabel)
        contentView.addSubview(trailCityLabel)
        contentView.addSubview(trailStateLabel)
        contentView.addSubview(trailZipCodeLabel)
        contentView.addSubview(trailDirectionsInfoLabel)
        
        NSLayoutConstraint.activate([
            trailAddressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            trailAddressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            trailAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trailCityLabel.topAnchor.constraint(equalTo: trailAddressLabel.bottomAnchor, constant: 2),
            trailCityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            trailStateLabel.topAnchor.constraint(equalTo: trailAddressLabel.bottomAnchor, constant: 2),
            trailStateLabel.leadingAnchor.constraint(equalTo: trailCityLabel.trailingAnchor),
            
            trailZipCodeLabel.topAnchor.constraint(equalTo: trailAddressLabel.bottomAnchor, constant: 2),
            trailZipCodeLabel.leadingAnchor.constraint(equalTo: trailStateLabel.trailingAnchor),
            
            trailDirectionsInfoLabel.topAnchor.constraint(equalTo: trailCityLabel.bottomAnchor, constant: 15),
            trailDirectionsInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            trailDirectionsInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            trailDirectionsInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
            
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HoursCell: UITableViewCell {
    
    var trailHoursLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        trailHoursLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        
        // Add the trailHoursLabel to the cell's content view
        contentView.addSubview(trailHoursLabel)
        
        // Configure constraints for trailHoursLabel
        NSLayoutConstraint.activate([
            trailHoursLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            trailHoursLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailHoursLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            trailHoursLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class HistoryCell: UITableViewCell {
    
    var trailHistoryLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        trailHistoryLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        
        // Add the trailHoursLabel to the cell's content view
        contentView.addSubview(trailHistoryLabel)
        
        // Configure constraints for trailHoursLabel
        NSLayoutConstraint.activate([
            trailHistoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            trailHistoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailHistoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            trailHistoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = sections[indexPath.section]
        let lightGray = UIColor(white: 0.9, alpha: 1.0)
        
        // Configure the cell based on its row and section
        if indexPath.row == 0 { // First row of the section
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = sectionName
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = lightGray
            cell.layer.borderWidth = 3.0
            cell.layer.borderColor = UIColor.white.cgColor
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            return cell
        }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "directionsCell", for: indexPath) as! DirectionsCell
            
            if let park = selectedPark {
                
                //unwrap [Addresses]
                if let park = selectedPark, let addresses = park.addresses, !addresses.isEmpty {
                    if let firstAddress = addresses.first {
                        let address = "\(firstAddress.line1)"
                        let city = "\(firstAddress.city), "
                        let state =  "\(firstAddress.stateCode) "
                        let postalCode = "\(firstAddress.postalCode)"
                        
                        cell.trailAddressLabel.text = address
                        cell.trailCityLabel.text = city
                        cell.trailStateLabel.text = state
                        cell.trailZipCodeLabel.text = postalCode
                    }
                } else {
                    // Handle the case where park.addresses is nil or empty
                    cell.trailAddressLabel.text = "Address not available"
                    cell.trailCityLabel.text = "City not available"
                    cell.trailStateLabel.text = "State not available"
                    cell.trailZipCodeLabel.text = "Postal code not available"
                }
                
                //Directions Info
                if let directions = park.directionsInfo {
                    let fullText = "Directions: \n\(directions)"
                    let attributedText = NSMutableAttributedString(string: fullText)
                    
                    //set to bold "Directions:"
                    let boldFont = UIFont.boldSystemFont(ofSize:  cell.trailDirectionsInfoLabel.font.pointSize)
                    attributedText.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: 11))
                    // Apply custom line height
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 3 // Adjust the line spacing as needed
                    attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
                    
                    cell.trailDirectionsInfoLabel.attributedText = attributedText
                } else {
                    cell.trailDirectionsInfoLabel.text = nil
                }
            }
            
            return cell
            
        //HOURS SECTION
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "hoursCell", for: indexPath) as! HoursCell
            
            if let park = selectedPark,
                let operationHours = park.operatingHours,
                let firstOperatingHours = operationHours.first,
                let standardHours = firstOperatingHours.standardHours {
                // Access the properties of the StandardHours object
                let sundayHours = standardHours.sunday
                let mondayHours = standardHours.monday
                let tuesdayHours = standardHours.tuesday
                let wednesdayHours = standardHours.wednesday
                let thursdayHours = standardHours.thursday
                let fridayHours = standardHours.friday
                let saturdayHours = standardHours.saturday
                
                let text = "Sunday: \(sundayHours)\nMonday: \(mondayHours)\nTuesday: \(tuesdayHours)\nWednesday: \(wednesdayHours)\nThursday: \(thursdayHours)\nFriday: \(fridayHours)\nSaturday: \(saturdayHours)\n\n"
                
                let attributedString = NSMutableAttributedString(string: text)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 5
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                
                cell.trailHoursLabel.attributedText = attributedString
            }
            return cell
        case 4:
            // HISTORY SECTION
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
            
            if let park = selectedPark {
                
                if let history =  park.description {
                    let fullText = "\(history)"
                    let attributedText = NSMutableAttributedString(string: fullText)
                    
                    //Set to bold the first two words
                    // Split the directions into words
                    let words = history.components(separatedBy: " ")
                    if let firstWord = words.first, let secondWord = words.dropFirst().first {
                        // Calculate the length of the first two words
                        let lengthOfFirstTwoWords = firstWord.count + secondWord.count + 1 // Add 1 for the space
                        // Create a range for the first two words
                        let range = NSRange(location: 0, length: lengthOfFirstTwoWords)
                        let boldFont = UIFont.boldSystemFont(ofSize: cell.trailHistoryLabel.font.pointSize)
                        // Apply bold font to the first two words
                        attributedText.addAttribute(.font, value: boldFont, range: range)
                    }
                    
                    // Apply custom line height
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 3
                    attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
                    
                    cell.trailHistoryLabel.attributedText = attributedText
                } else {
                    cell.trailHistoryLabel.text = nil
                }
            }
            return cell
            
        default:
            // Handle other sections or rows if necessary
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //set header rows at height of 55
        if indexPath.row == 0 {
            return 50
        } else {
            // otherwise for row 1 - make cell height dynamic
            return UITableView.automaticDimension }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check if the section index is less than the count of the 'collapsed' array
        if section < collapsed.count {
            // If expanded, show 2 rows (1 header + 1 detail), otherwise, show 1 row (header only)
            return collapsed[section] ? 1 : 2
        } else {
            // If the section index is not less than the count of the 'collapsed' array, return 0
            // This could be a default value or an error handling case
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If user tapped the first row
        if indexPath.row == 0 {
            // Toggle the collapsed state via the collapse array for the value at the index section
            collapsed[indexPath.section] = !collapsed[indexPath.section]
            
            // Update the section with animation
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            
            // Deselect the row that was just selected
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

