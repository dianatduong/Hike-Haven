

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
   // var accordionVC = AccordionViewController()
    var accordionData: [OperatingHours] = []
    var weatherArray: [Periods] = []
    var parksArray: [ParkData] = []
    
    var sections: [String] = ["Hours", "Weather", "Contacts", "History"]
    var collapsed: [Bool] = [true, true, true, true]
    
    //passed data from VC
    var selectedPark: ParkData?   //property to hold the selected park
    var selectedUnsplashData: UnSplashData?
    var selectedWeatherData: Periods?

        
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
    var trailHoursLabel: UILabel!
     var trailDirectionsInfoLabel: UILabel!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       // navigationItem.largeTitleDisplayMode = .never
       // title = "Trail"
        
        setUpUI()
        getData()
        setUpAccordionTableView()
    }
    
    
    

    //used to populate the UI elements with data received from ViewController
    func getData() {
        // Update labels with the park data
        if let park = selectedPark, let unsplashData = selectedUnsplashData {
            selectedNameLabel.text = park.fullName
            trailDirectionsInfoLabel.text = park.directionsInfo
            
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
        trailAddressLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailCityLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailStateLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailZipCodeLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailDirectionsInfoLabel = createLabel(font: UIFont.systemFont(ofSize: 16.5))
        trailHoursLabel = createLabel(font: UIFont.systemFont(ofSize: 17))

        trailInfoContainerView.addSubview(trailAddressLabel)
        trailInfoContainerView.addSubview(trailCityLabel)
        trailInfoContainerView.addSubview(trailStateLabel)
        trailInfoContainerView.addSubview(trailZipCodeLabel)
        trailInfoContainerView.addSubview(trailDirectionsInfoLabel)
        
        view.addSubview(trailInfoContainerView)
        view.addSubview(selectedImageView)
        selectedImageView.addSubview(textShadowLayer)
        textShadowLayer.addSubview(selectedNameLabel)
        view.addSubview(trailInfoContainerView)

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
        trailDirectionsInfoLabel.translatesAutoresizingMaskIntoConstraints = false
       // accordionVC.view.translatesAutoresizingMaskIntoConstraints = false
        
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
            
           trailDirectionsInfoLabel.topAnchor.constraint(equalTo: trailCityLabel.bottomAnchor, constant: 12),
            trailDirectionsInfoLabel.leadingAnchor.constraint(equalTo: trailInfoContainerView.leadingAnchor, constant: 15),
            trailDirectionsInfoLabel.trailingAnchor.constraint(equalTo: trailInfoContainerView.trailingAnchor, constant: -20)
        ])
    }
    
    func setUpAccordionTableView() {
        //UITableView for the accordion-style view
        let accordionTableView = UITableView()
        accordionTableView.translatesAutoresizingMaskIntoConstraints = false
        accordionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        accordionTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherCell")
        
        accordionTableView.dataSource = self
        accordionTableView.delegate = self
        accordionTableView.separatorStyle = .none
        
        view.addSubview(accordionTableView)
        
        
        NSLayoutConstraint.activate([
            accordionTableView.topAnchor.constraint(equalTo: trailDirectionsInfoLabel.bottomAnchor, constant: 25),
            accordionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accordionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accordionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}
    extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // Set the height of the row based on its section
            
            // HOURS SECTION
            if indexPath.section == 0 && indexPath.row == 1 {
                return 200
            }
             // WEATHER SECTION
            else if indexPath.section == 1 && indexPath.row == 1 {
                return 180
            }
            
            // CONTACT SECTION
            else if indexPath.section == 2 && indexPath.row == 1 {
                return 55
            }
                
            // HISTORY SECTION
              else if indexPath.section == 3 && indexPath.row == 1 {
                return 250
            }
            return 55 // All others

        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return sections.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Check if the section index is less than the count of the 'collapsed' array
            if section < collapsed.count {
                // If it is, return 1 or 2 based on the boolean value at that index in the 'collapsed' array
                // If the section is collapsed (true), return 1 row. If not collapsed (false), return 2 rows.
                return collapsed[section] ? 1 : 2
            } else {
                // If the section index is not less than the count of the 'collapsed' array, return 0
                // This could be a default value or an error handling case
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let sectionName = sections[indexPath.section]
            let lightGray = UIColor(white: 0.9, alpha: 1.0)
            
            // Configure the cell based on its row and section
            if indexPath.row == 0 { // First row of the section
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                cell.textLabel?.text = sectionName
                cell.accessoryType = .disclosureIndicator
                cell.backgroundColor = lightGray
                cell.layer.borderWidth = 3.0 // The width of the border
                cell.layer.borderColor = UIColor.white.cgColor
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
                return cell
                
                //HOURS SECTION
            } else if indexPath.section == 0 && indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                if let park = selectedPark {
                    // Unwrap OperatingHours [StandardHours]
                    if let operationHours = park.operatingHours,
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
                        
                        let text = "Sunday:  \(sundayHours) \nMonday:  \(mondayHours) \nTuesday:  \(tuesdayHours) \nWednesday:  \(wednesdayHours) \nThursday:  \(thursdayHours) \nFriday:  \(fridayHours) \nSaturday:  \(saturdayHours)\n\n"
                        
                        //creates line height
                        let attributedString = NSMutableAttributedString(string: text)
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 5 // adjust the line spacing here
                        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                        
                        let trailHoursLabel = UILabel()
                        trailHoursLabel.attributedText = attributedString
                        trailHoursLabel.numberOfLines = 0 // Allow multiple lines
                        trailHoursLabel.lineBreakMode = .byWordWrapping // Wrap text at word boundaries
                        cell.contentView.addSubview(trailHoursLabel)
                        
                        //constraints for the UILabel
                        trailHoursLabel.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            trailHoursLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
                            trailHoursLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                            trailHoursLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                            trailHoursLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10)
                        ])
                        
                        return cell
                    }
                }
                
                
                //WEATHER SECTION
            } else if indexPath.section == 0 && indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                return cell
                
                
                //CONTACTS SECTION
            } else if indexPath.section == 0 && indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                return cell
                
                
                //HISTORY SECTION
            } else if indexPath.section == 3 && indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                
                if let park = selectedPark {
                    cell.textLabel?.text = park.description
                    cell.accessoryType = .none
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.lineBreakMode = .byWordWrapping
                    return cell
                }
                
            }
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Check if the first row of a section is selected
            if indexPath.row == 0 {
                // Toggle the collapsed state for this section
                collapsed[indexPath.section] = !collapsed[indexPath.section]

                // Check the new collapsed state for this section
                if collapsed[indexPath.section] {
                    // If the section is now collapsed, delete the second row of this section
                    tableView.deleteRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
                } else {
                    // If the section is now expanded, insert the second row of this section
                    tableView.insertRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
                }

                // Deselect the row that was just selected
                tableView.deselectRow(at: indexPath, animated: true)
            }
        } // End of tableView(_:didSelectRowAt:)
    }

   
           /*
           accordionVC.view.topAnchor.constraint(equalTo: trailDescriptionLabel.bottomAnchor, constant: 25),
           accordionVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           accordionVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           accordionVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            */
