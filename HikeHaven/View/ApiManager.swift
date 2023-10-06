//
//  ApiManager.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import Foundation

/*class APIManager {
    

    static let shared = APIManager()
    let vc = ViewController()
    
   // var unsplashArray: [UnSplashData] = []
    //var parksArray: [ParkData] = []
    var weatherArray: [Periods] = []
    
    private init() {}
    
    func fetchImagesAPI(searchTerm: String, completion: @escaping ([UnSplashData]?) -> Void) {
        // Your fetchImagesAPI implementation here
        // ...
        // Call the completion handler with the fetched data
        completion(unsplashArray)
    }
    
    func fetchDataAPI(searchTerm: String, completion: @escaping ([ParkData]?) -> Void) {
        
        // Define the URL for the API request
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?limit=20&q=\(searchTerm)")!
        
        // Create a URLRequest object
        var request = URLRequest(url: url)
        request.addValue("WKsNM1QPZ90IJLcgF7zsufYJQh8nCyACrTtoEABo", forHTTPHeaderField: "x-api-key")
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
                // Decode the JSON data into a Park object
                let parkResponse = try JSONDecoder().decode(Park.self, from: data)
                
                // Update the parksArray property with the results
                self.vc.parksArray = parkResponse.data
                
                // Print the results to the console
                //print(parkResponse.data)
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self.vc.tableView.reloadData()
                }
            } catch {
                // Handle any decoding errors
                print(error.localizedDescription)
            }
        }
        // Start the URLSession data task
        task.resume()
        
        completion(parksArray)
    }
    
    func fetchWeatherAPI(completion: @escaping ([Periods]?) -> Void) {
        // Your fetchWeatherAPI implementation here
        // ...
        // Call the completion handler with the fetched data
        completion(weatherArray)
    }
}

*/
