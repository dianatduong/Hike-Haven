

//
//  AccordionViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/14/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class AccordionViewController: UITableViewController {
    
    var sections: [String] = ["Hours", "Weather", "Contacts"]
    var collapsed: [Bool] = [true, true, true]

    var parksArray: [ParkData] = []
    var weatherArray: [Periods] = []
            
    
    override func viewDidLoad() {
    super.viewDidLoad()
        configureTableView()
        fetchWeatherAPI()
    }
        
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherCell")

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    

     func fetchWeatherAPI() {
         // Define the URL for the API request
         let url = URL(string: "https://api.weather.gov/gridpoints/TOP/31,80/forecast")!
         
         // Create a URLRequest object
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         
         // Create a URLSession data task
         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             // Handle any errors
             if let error = error {
                 print(error.localizedDescription)
                 return
             }
             
             // Ensure data is returned from the API
             guard let data = data else {
                 print("No data returned from API.")
                 return
             }
             
             do {
                 // Decode the JSON data into a WeatherData object
                 let weatherResponse = try JSONDecoder().decode(WeatherData.self, from: data)
                 
                 // Update the weatherArray property with the results
                 self.weatherArray = weatherResponse.properties?.periods ?? []
                 
                 // Reload the table view on the main thread
                 DispatchQueue.main.async {
                     self.tableView.reloadData()
                 }
             } catch {
                 // Handle any decoding errors
                 print(error.localizedDescription)
             }
         }
         
         // Start the URLSession data task
         task.resume()
     }
           
        
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // Set the height of the row based on its section
       if indexPath.section == 0 && indexPath.row == 1 {
           return 200 // Hours content section
       } else if indexPath.section == 1 && indexPath.row == 1 {
           return 180 // Weather content section
       } else {
           return 55 // All others
       }
   }

   override func numberOfSections(in tableView: UITableView) -> Int {
       // Set the number of sections based on the table view tag
       if tableView.tag == 0 || tableView.tag == 1 {
           return parksArray.count
       } else {
           return sections.count
       }
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // Set the number of rows in each section
       if section < collapsed.count {
           return collapsed[section] ? 1 : 2 // Toggle another row for sections 1-3
       } else {
           return 0 // Default value or handle the error appropriately
       }
   }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        } else { // Second row of each section
            if indexPath.section == 0 { // Hours section
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                for park in parksArray {
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

                        let text = "\nSunday: \(sundayHours) \nMonday: \(mondayHours) \nTuesday: \(tuesdayHours) \nWednesday: \(wednesdayHours) \nThursday: \(thursdayHours) \nFriday: \(fridayHours) \nSaturday: \(saturdayHours)\n\n"
                        
                        cell.textLabel?.text = text
                        cell.accessoryType = .none
                        cell.textLabel?.numberOfLines = 0 // Allow multiple lines
                        cell.textLabel?.lineBreakMode = .byWordWrapping // Wrap text at word boundaries
                        
                        return cell
                    }
                }
            }
        }
    
         if indexPath.section == 1 { // Weather section
                if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell {
                    let weatherDetails = weatherArray[indexPath.row]
                    
                    // Unwrap [Forecast]
                    if let forecast = weatherDetails.detailedForecast {
                        let label = "\(forecast))"
                        cell.weatherLabel.text = label
                    }
                    
                    // Unwrap [Temperature]
                    if let temperature = weatherDetails.temperature {
                        cell.tempLabel.text = "\(temperature) ℉"
                    } else {
                        // Handle the case where the temperature value is nil
                        cell.tempLabel.text = "Temperature not available"
                    }

                    // Unwrap [Icon]
                    if let imageURLString = weatherDetails.icon,
                       let imageURL = URL(string: imageURLString) {
                        URLSession.shared.dataTask(with: imageURL) { data, response, error in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            guard let data = data else {
                                print("No data returned from image URL.")
                                return
                            }
                            DispatchQueue.main.async {
                                cell.weatherIcon.image = UIImage(data: data)
                            }
                        }.resume()
                    }
                    
                    cell.accessoryType = .none
                    cell.textLabel?.numberOfLines = 0 // Allow multiple lines
                    cell.textLabel?.lineBreakMode = .byWordWrapping // Wrap text at word boundaries
                    
                    return cell
                }
            } else if indexPath.section == 2 { // Contacts section
                  let cell=tableView.dequeueReusableCell(withIdentifier:"cell",for:indexPath)
                          cell.textLabel?.text="contact details"
                          cell.accessoryType = .none
                          return cell
            }
            
            return UITableViewCell() // Default case
        }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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


if let cell = tableView.dequeueReusableCell(withIdentifier:"cell",for:indexPath) as? ContactsTableViewCell {

        let park = parksArray[indexPath.row]
    
        let contactsArray = park.contacts
        for contact in contactsArray {
            if let phoneNumbersArray = contact.phoneNumbers {
                for phoneNumber in phoneNumbersArray {
                    let number = phoneNumber.phoneNumber
                    let text = "Phone Number: \(number)"
                    cell.phoneNumber.text = text
                }
            }
        
            if let emailAddressesArray = contact.emailAddresses {
            for emailAddress in emailAddressesArray {
                let email = emailAddress.emailAddress
                let text = "Email Address: \(email)"
                    cell.emailAddress.text = text
                }
            }

        }
        
}}
*/
