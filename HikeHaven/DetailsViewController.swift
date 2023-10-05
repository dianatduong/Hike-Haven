//
//  DetailsViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

extension String {
    func truncate(length: Int) -> String {
        if self.count > length {
            let endIndex = self.index(self.startIndex, offsetBy: length)
            return String(self[..<endIndex])
        } else {
            return self
        }
    }
}

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
    var sections: [String] = ["Directions", "Park Hours", "Weather Overview", "Contact Info"]
    var collapsed: [Bool] = [false, true, true, true]
    
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
        
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        textShadowLayer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectedImageView.heightAnchor.constraint(equalToConstant: 270),
            
            textShadowLayer.topAnchor.constraint(equalTo: selectedImageView.topAnchor, constant: 195),
            textShadowLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textShadowLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            selectedNameLabel.topAnchor.constraint(equalTo: selectedImageView.topAnchor, constant: 195),
            selectedNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
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
    
    //UITableView for the accordion-style view
    func setUpAccordionTableView() {
        let accordionTableView = UITableView()
        accordionTableView.translatesAutoresizingMaskIntoConstraints = false
        accordionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        accordionTableView.register(ContactsCell.self, forCellReuseIdentifier: "contactsCell")
        accordionTableView.register(DirectionsCell.self, forCellReuseIdentifier: "directionsCell")
        accordionTableView.register(HistoryCell.self, forCellReuseIdentifier: "historyCell")
        accordionTableView.register(HoursCell.self, forCellReuseIdentifier: "hoursCell")
        accordionTableView.register(WeatherCell.self, forCellReuseIdentifier: "weatherCell")

        
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
}

class ContactsCell: UITableViewCell {
    
    var phoneNumberLabel: UILabel!
    var emailAddressLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        phoneNumberLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        emailAddressLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))

        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(emailAddressLabel)
   
        NSLayoutConstraint.activate([
            phoneNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            emailAddressLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 15),
            emailAddressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            emailAddressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)

        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DirectionsCell: UITableViewCell {
    
    var trailNameLabel: UILabel!
    var trailAddressLabel: UILabel!
    var trailCityLabel: UILabel!
    var trailStateLabel: UILabel!
    var trailZipCodeLabel: UILabel!
    var trailDirectionsInfoLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        trailNameLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .semibold))
        trailAddressLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailCityLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailStateLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailZipCodeLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailDirectionsInfoLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailDirectionsInfoLabel.isUserInteractionEnabled = true
        
        contentView.addSubview(trailNameLabel)
        contentView.addSubview(trailAddressLabel)
        contentView.addSubview(trailCityLabel)
        contentView.addSubview(trailStateLabel)
        contentView.addSubview(trailZipCodeLabel)
        contentView.addSubview(trailDirectionsInfoLabel)
        
        NSLayoutConstraint.activate([
            trailNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            trailNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trailAddressLabel.topAnchor.constraint(equalTo: trailNameLabel.bottomAnchor, constant: 4),
            trailAddressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trailDirectionsInfoLabel.topAnchor.constraint(equalTo: trailAddressLabel.bottomAnchor, constant: 15),
            trailDirectionsInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailDirectionsInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            trailDirectionsInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)

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
            trailHistoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            trailHistoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailHistoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            trailHistoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HoursCell: UITableViewCell {
    
    var trailHoursLabel: UILabel!
    var trailHolidayHours: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        trailHoursLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))
        trailHolidayHours = createLabel(font: UIFont.italicSystemFont(ofSize: 16))

        // Add the trailHoursLabel to the cell's content view
        contentView.addSubview(trailHoursLabel)
        contentView.addSubview(trailHolidayHours)

        // Configure constraints for trailHoursLabel
        NSLayoutConstraint.activate([
            trailHoursLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            trailHoursLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailHoursLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            trailHolidayHours.topAnchor.constraint(equalTo: trailHoursLabel.bottomAnchor, constant: 20),
            trailHolidayHours.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trailHolidayHours.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            trailHolidayHours.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WeatherCell: UITableViewCell {

    var weatherLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        weatherLabel = createLabel(font: UIFont.systemFont(ofSize: 17, weight: .regular))

        contentView.addSubview(weatherLabel)
        
        NSLayoutConstraint.activate([
            weatherLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            weatherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weatherLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            weatherLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailsViewController {
    
 // Helper function to configure Directions cell
 func configureDirectionsCell(_ cell: DirectionsCell) {
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
             let attributedAddress = NSMutableAttributedString(string: "\(address) \(city) \(state) \(postalCode)")
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
                
                let words = weather.components(separatedBy: " ")
                if let firstWord = words.first, let secondWord = words.dropFirst().first {
                    let lengthOfFirstTwoWords = firstWord.count + secondWord.count + 1
                    let range = NSRange(location: 0, length: lengthOfFirstTwoWords)
                    let boldFont = UIFont.boldSystemFont(ofSize: cell.weatherLabel.font.pointSize)
                    attributedText.addAttribute(.font, value: boldFont, range: range)
                }
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3
                attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
                
                cell.weatherLabel.attributedText = attributedText
            } else {
                cell.weatherLabel.text = "Weather info is unavailable at this time"
            }
        }
    }
    
}


extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Update tableView(_:cellForRowAt:) method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = sections[indexPath.section]
        let lightGray = UIColor(white: 0.9, alpha: 1.0)
        
        if indexPath.row == 0 {
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
            configureDirectionsCell(cell)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "hoursCell", for: indexPath) as! HoursCell
            configureHoursCell(cell)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherCell
            configureWeatherCell(cell)
            return cell
        case 3:
           let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as! ContactsCell
           configureContactsCell(cell)
           return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
            configureHistoryCell(cell)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
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
        
        /*
         //displays all headers
         if indexPath.row == 0 {
            return 50
         } else {
            // otherwise for row 1 - make cell height dynamic
            return UITableView.automaticDimension }
         }
         */
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
