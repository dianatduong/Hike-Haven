//
//  DetailsViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //API
    var parksArray: [ParkData] = []
    // var weatherArray: [Periods] = []
    
    //passed data from VC
    var selectedPark: ParkData?
    var selectedUnsplashData: UnSplashData?
    //var selectedWeatherData: Periods?
    
    //data for the accordion sections
    var sections: [String] = ["Directions", "History", "Weather Overview", "Park Hours", "Contact Info"]
    var collapsed: [Bool] = [false, true, true, true, true]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGray6
        
        //contstraints for image + name
        UIManager.shared.setUpUI(forView: view)
        
        AccordionManager.shared.accordionTableView.dataSource = self
        AccordionManager.shared.accordionTableView.delegate = self
        AccordionManager.shared.setUpAccordion(forView: view)
        
        //fetching api for image + name data
        getUIData()
    }
    
    
    //populate the UI elements with data received from ViewController
    func getUIData() {
        // Update labels with the park data
        if let park = selectedPark, let unsplashData = selectedUnsplashData {
            
            //Park Name
            UIManager.shared.selectedNameLabel.text = park.fullName
            navigationItem.largeTitleDisplayMode = .never
            title = park.fullName
            
            // Load and display the image via loadImage function from vc
            if let imageURLString = unsplashData.urls.regular,
                let imageURL = URL(string: imageURLString) {
                APIManager.shared.loadImage(from: imageURL) { image in
                    DispatchQueue.main.async {
                        UIManager.shared.selectedImageView.image = image
                    }
                }
            }
        }
    }
    
    
//MARK: -  Accordion TableViewCells configurations
    
    // Helper function to configure Directions cell
    func configureDirectionsCell(_ cell: DirectionsCell) {
        
        //ADDRESS
        if let park = selectedPark {
            if let addresses = park.addresses, let firstAddress = addresses.first {
                let address = "\(firstAddress.line1)"
                let city = "\(firstAddress.city),"
                let state = "\(firstAddress.stateCode)"
                let postalCode = "\(firstAddress.postalCode)"
                
                // Create a tap gesture recognizer for the address label
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openInGoogleMaps(_:)))
                cell.trailAddressLabel.isUserInteractionEnabled = true
                cell.trailAddressLabel.addGestureRecognizer(tapGesture)
                cell.trailAddressLabel.tag = 1 // Set a tag to identify the label
                
                // Create an attributed string for the address label
                let attributedAddress = NSMutableAttributedString(string: "\(address)\n \(city) \(state) \(postalCode)")
                let boldFont = UIFont.boldSystemFont(ofSize: cell.trailAddressLabel.font.pointSize)
                attributedAddress.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: attributedAddress.length))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                attributedAddress.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedAddress.length))
                
                // Construct the Google Maps URL with city, state, and ZIP code
                let googleMapsQuery = "\(address) \(city) \(state) \(postalCode)"
                if let encodedQuery = googleMapsQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    let googleMapsURL = "googlemaps://?q=\(encodedQuery)"
                    let linkAttributes: [NSAttributedString.Key: Any] = [
                        .link: googleMapsURL,
                        .underlineStyle: NSUnderlineStyle.single.rawValue
                    ]
                    attributedAddress.addAttributes(linkAttributes, range: NSRange(location: 0, length: attributedAddress.length))
                }
                cell.trailAddressLabel.attributedText = attributedAddress
                
            } else {
                cell.trailAddressLabel.text = "Address not available"
            }
            
            //DIRECTIONS INFO
            if let directions = park.directionsInfo {
                let fullText = "Directions: \n\(directions)"
                let attributedText = NSMutableAttributedString(string: fullText)
                let boldFont = UIFont.boldSystemFont(ofSize: cell.trailDirectionsInfoLabel.font.pointSize)
                attributedText.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: 11))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
                
                cell.trailDirectionsInfoLabel.attributedText = attributedText
            } else {
                cell.trailDirectionsInfoLabel.text = nil
            }
            //PARK NAME
            cell.trailNameLabel.text = park.fullName
        }
    }
    @objc func openInGoogleMaps(_ sender: UITapGestureRecognizer) {
        if let addressLabel = sender.view as? UILabel,
            let park = selectedPark,
            let addresses = park.addresses,
            let firstAddress = addresses.first,
            addressLabel.tag == 1 { // Check if it's the address label
            
            let address = "\(firstAddress.line1), \(firstAddress.city), \(firstAddress.stateCode) \(firstAddress.postalCode)"
            if let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                let urlString = "https://www.google.com/maps/search/?api=1&query=\(encodedAddress)"
                if let url = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Handle the case where Google Maps cannot be opened
                        let alertController = UIAlertController(title: "Error", message: "Google Maps or Safari cannot be opened.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    // Helper function to configure Hours cell
    func configureHoursCell(_ cell: HoursCell) {
        if let park = selectedPark,
            let operatingHours = park.operatingHours,
            let firstOperatingHours = operatingHours.first,
            let standardHours = firstOperatingHours.standardHours {
            
            let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            let hoursText = "Sunday: \(standardHours.sunday)\nMonday: \(standardHours.monday)\nTuesday: \(standardHours.tuesday)\nWednesday: \(standardHours.wednesday)\nThursday: \(standardHours.thursday)\nFriday: \(standardHours.friday)\nSaturday: \(standardHours.saturday)"
            
            let attributedText = NSMutableAttributedString(string: hoursText)
            
            for day in daysOfWeek {
                if let range = hoursText.range(of: "\(day):") {
                    let nsRange = NSRange(range, in: hoursText)
                    attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: nsRange)
                }
            }
            
            let holidayText = "*Please refer to Park’s website for Holiday hours."
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
            
            cell.trailHoursLabel.attributedText = attributedText
            cell.trailHolidayHours.text = holidayText
        }
    }
    
    func formatPhoneNumber(_ phoneNumber: String) -> String {
        // Remove any characters that are not digits
        let digitsOnly = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Check if the phone number has enough digits
        guard digitsOnly.count == 10 else {
            return "Invalid phone number"
        }
        // Split the digits into groups and format
        let areaCode = digitsOnly.prefix(3)
        let prefix = digitsOnly.dropFirst(3).prefix(3)
        let lineNumber = digitsOnly.dropFirst(6)
        
        let formattedNumber = "(\(areaCode)) \(prefix)-\(lineNumber)"
        return formattedNumber
    }
    
    // Helper function to configure History cell
    func configureContactsCell(_ cell: ContactsCell) {
        if let park = selectedPark, let contacts = park.contacts {
            // Create attributed strings with bold text for labels
            let phoneNumberText = "Phone Number:  \n"
            let emailAddressText = "Email Address:  \n"
            let boldAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
            
            // Define line height
            let lineHeight: CGFloat = 5.0
            
            // Unwrap phone numbers
            if let phoneNumber = contacts.phoneNumbers.first?.phoneNumber {
                let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
                let attributedPhoneNumber = NSMutableAttributedString(string: phoneNumberText, attributes: boldAttributes)
                attributedPhoneNumber.append(NSAttributedString(string: formattedPhoneNumber))
                
                // Apply line height to the entire attributed string
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = lineHeight
                attributedPhoneNumber.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedPhoneNumber.length))
                
                cell.phoneNumberLabel.attributedText = attributedPhoneNumber
            } else {
                cell.phoneNumberLabel.text = "Phone Number not available"
            }
            
            // Unwrap email addresses
            if let emailAddress = contacts.emailAddresses.first?.emailAddress {
                let attributedEmailAddress = NSMutableAttributedString(string: emailAddressText, attributes: boldAttributes)
                attributedEmailAddress.append(NSAttributedString(string: emailAddress))
                
                // Apply line height to the entire attributed string
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = lineHeight
                attributedEmailAddress.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedEmailAddress.length))
                
                cell.emailAddressLabel.attributedText = attributedEmailAddress
            } else {
                cell.emailAddressLabel.text = "Email Address not available"
            }
        }
    }
    
    
    // Helper function to configure History cell
    func configureHistoryCell(_ cell: HistoryCell) {
        if let park = selectedPark {
            if let history = park.description {
                let fullText = "\(history)"
                let attributedText = NSMutableAttributedString(string: fullText)
                
                let words = history.components(separatedBy: " ")
                if let firstWord = words.first, let secondWord = words.dropFirst().first {
                    let lengthOfFirstTwoWords = firstWord.count + secondWord.count + 1
                    let range = NSRange(location: 0, length: lengthOfFirstTwoWords)
                    let boldFont = UIFont.boldSystemFont(ofSize: cell.trailHistoryLabel.font.pointSize)
                    attributedText.addAttribute(.font, value: boldFont, range: range)
                }
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
                
                cell.trailHistoryLabel.attributedText = attributedText
            } else {
                cell.trailHistoryLabel.text = "History information is unavailable at this time."
            }
        }
    }
    
    // Helper function to configure Weather cell
    func configureWeatherCell(_ cell: WeatherCell) {
        if let park = selectedPark {
            if let weather = park.weatherInfo {
                let fullText = "\(weather)"
                let attributedText = NSMutableAttributedString(string: fullText)
                
                //Styling the first two words to bold text
                let words = weather.components(separatedBy: " ")
                if let firstWord = words.first, let secondWord = words.dropFirst().first {
                    let lengthOfFirstTwoWords = firstWord.count + secondWord.count + 1
                    let range = NSRange(location: 0, length: lengthOfFirstTwoWords)
                    let boldFont = UIFont.boldSystemFont(ofSize: cell.weatherLabel.font.pointSize)
                    attributedText.addAttribute(.font, value: boldFont, range: range)
                }
                //line height
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
                
                cell.weatherLabel.attributedText = attributedText
            } else {
                cell.weatherLabel.text = "Weather info is unavailable at this time"
            }
        }
    }
    
} // end class


//MARK: - UITableViewCells

extension DetailsViewController: UITableViewDataSource {
    
    //ACCORDION SECTIONS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = sections[indexPath.section]
        
        //stylizing the first row
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = sectionName
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.systemGray2
            cell.layer.borderWidth = 3.0
            cell.layer.borderColor = UIColor.systemGray6.cgColor
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            return cell
        }
        
        //configuring the contents of each accordion cell
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "directionsCell", for: indexPath) as! DirectionsCell
            configureDirectionsCell(cell)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
            configureHistoryCell(cell)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherCell
            configureWeatherCell(cell)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "hoursCell", for: indexPath) as! HoursCell
            configureHoursCell(cell)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as! ContactsCell
            configureContactsCell(cell)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Configuring collapse/expand for section header
        if section == 0 {
            return collapsed[section] ? 1 : 2 // For section 0, return 2 rows (header + cell) if expanded
        } else {
            // For other sections, follow your existing logic
            if section < collapsed.count {
                return collapsed[section] ? 1 : 2
            } else {
                return 0
            }
        }
    }
}


extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //hides "Directions" header for section 0
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 0 // Hide the header cell in section 0
            } else {
                return UITableView.automaticDimension // Make cell height dynamic for section 0, row 1
            }
        } else {
            // For other sections, set the header row's height to 50 and dynamic height for row 1
            return indexPath.row == 0 ? 50 : UITableView.automaticDimension
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
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
