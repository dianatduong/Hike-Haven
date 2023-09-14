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
            fetchDataAPI()
            fetchWeatherAPI()
         
        }
        
        func configureTableView() {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherCell")

            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
        }
        
        
        func fetchDataAPI() {
            let searchTerm = "mn"
            let url = URL(string: "https://developer.nps.gov/api/v1/parks?limit=6&stateCode=\(searchTerm)")!
            var request = URLRequest(url: url)
            request.addValue("WKsNM1QPZ90IJLcgF7zsufYJQh8nCyACrTtoEABo", forHTTPHeaderField: "x-api-key")
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let data = data else {
                    print("No data returned from API.")
                    return
                }
                do {
                    let parkResponse = try JSONDecoder().decode(Park.self, from: data)
                    self.parksArray = parkResponse.data
                    print(parkResponse)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
        
     
           func fetchWeatherAPI() {
          
             let url = URL(string: "https://api.weather.gov/gridpoints/TOP/31,80/forecast")!
             var request = URLRequest(url: url)
             request.httpMethod = "GET"

             let task = URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
                 print(error.localizedDescription)
                 return
               }
               guard let data = data else {
                 print("No data returned from API.")
                 return
               }
               do {
                   let weatherResponse = try JSONDecoder().decode(WeatherData.self, from: data)
                   self.weatherArray = weatherResponse.properties?.periods ?? []
                 //print(weatherResponse)

                 DispatchQueue.main.async {
                   self.tableView.reloadData()
                 }
               } catch {
                 print(error.localizedDescription)
               }
             }
             task.resume()
           }
        
       override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             

                 //Hours content section
             if indexPath.section == 0 && indexPath.row == 1 {
                 return 200
                
                //weather content section
            } else if indexPath.section == 1 && indexPath.row == 1 {
                        return 180
                 
                 //all others
             } else  {
                 return 55
             }
         }
        
           override func numberOfSections(in tableView: UITableView) -> Int {
              
                 if tableView.tag == 0 || tableView.tag == 1{
                     return parksArray.count
                 } else  {
                   
                     return sections.count
                  }
          }
            
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             if section < collapsed.count {
                 //otherwise for sections 1 -3 - all toggle of another row
                 return collapsed[section] ? 1 : 2
             } else {
                 // Return a default value or handle the error appropriately
                 return 0
             }
         }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let sectionName = sections[indexPath.section]
            let lightGray = UIColor(white: 0.9, alpha: 1.0)

    //first row of the section
    if indexPath.row == 0  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                   cell.textLabel?.text = sectionName
                   cell.accessoryType = .disclosureIndicator
                   cell.backgroundColor = lightGray
                   cell.layer.borderWidth = 3.0 // The width of the border
                   cell.layer.borderColor = UIColor.white.cgColor
                   cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
                return cell
            }
            
        
            //otherwise in the second row of each section
            //if hours section
            if indexPath.section == 0  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                for park in parksArray {
                    //unwrap OperatingHours [StandardHours]
                    if let operationHours = park.operatingHours {
                        // Get the first OperatingHours object from the array
                        if let firstOperatingHours = operationHours.first {
                            // Unwrap the standardHours object
                            if let standardHours = firstOperatingHours.standardHours {
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
            }
            
            // if weather section
            if indexPath.section == 1 {

                if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell {
                    
                    let weatherDetails = weatherArray[indexPath.row]
                    
                    //unwrap [Forecast]
                    if let forecast = weatherDetails.detailedForecast {
                        let label = "\(forecast))"
                        
                        cell.weatherLabel.text = label
                        //print(label)
                    }
                    
                   if let temperature = weatherDetails.temperature {
                        cell.tempLabel.text = "\(temperature) ℉"
                    } else {
                        // Handle the case where the temperature value is nil
                        cell.tempLabel.text = "Temperature not available"
                    }


                    //unwrap [icon]
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
                  //  cell.weatherOverviewLabel.text = park.weatherOverview
                    //print(park.weatherOverview!)
                    cell.accessoryType = .none
                    cell.textLabel?.numberOfLines = 0 // Allow multiple lines
                    cell.textLabel?.lineBreakMode = .byWordWrapping // Wrap text at word boundaries
                
                    
                    return cell
                }
                
            
                           
                   
                           
            }
            //if contacts section
            else if indexPath.section == 2 {
                let cell=tableView.dequeueReusableCell(withIdentifier:"cell",for:indexPath)
                cell.textLabel?.text="contact details"
                cell.accessoryType = .none
                return cell
            }
            
            return UITableViewCell()
        }

        
        
        
        
                   //when a row is selected by a user
                 override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                     
                      //users expand and collapse sections of the table view by selecting the first row of each section
                    if indexPath.row == 0 {
                         // The value of collapsed[indexPath.section] is toggled between true and false
                         collapsed[indexPath.section] = !collapsed[indexPath.section]

                         // If the section is collapsed == true
                         if collapsed[indexPath.section] {
                             // The second row of the section is deleted
                             tableView.deleteRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
                         } else {
                             // If the section is not collapsed == false
                             // The second row of the section is inserted
                             tableView.insertRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
                         }

                         // The selected row is deselected using the
                         tableView.deselectRow(at: indexPath, animated: true)
                     }
                       
                 } // end didSelectRowAt
        }// end class

