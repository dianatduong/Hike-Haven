//
//  ApiManager.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class APIManager {
    
    static let shared = APIManager()
    
    // Add the imageCache property
    private let imageCache = NSCache<NSString, UIImage>()
        
    func fetchImagesAPI(searchTerm: String, completion: @escaping ([UnSplashData]?) -> Void) {
        
        if let apiKey = Bundle.main.infoDictionary?["UNSPLASH_API_KEY"] as? String {

        let url = URL(string: "https://api.unsplash.com/search/photos?client_id=\(apiKey)&count=1&query=\(searchTerm)+national+parks&per_page=20&orientation=landscape&order_by=popular&color=blue")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = Double.infinity
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data returned from API.")
                completion(nil)
                return
            }
            do {
                let imageResponse = try JSONDecoder().decode(UnSplashStruct.self, from: data)
                let unsplashArray = imageResponse.results
                completion(unsplashArray)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }
        task.resume()
    }
}
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                }
                guard let data = data else {
                    print("No data returned from image URL.")
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data) {
                        self.imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                        completion(downloadedImage)
                    }
                }
            }.resume()
        }
    }
    
        
    func fetchDataAPI(searchTerm: String, completion: @escaping ([ParkData]?) -> Void) {

        if let apiKey = Bundle.main.infoDictionary?["NPS_API_KEY"] as? String {
            // Define the URL for the API request
            let url = URL(string: "https://developer.nps.gov/api/v1/parks?q=\(searchTerm)&api_key=\(apiKey)")!
            
            // Create a URLRequest object
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Create a URLSession data task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle any errors
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                
                // Ensure data is returned from the API
                guard let data = data else {
                    print("No data returned from API.")
                    completion(nil)
                    return
                }
                
                do {
                    let parkResponse = try JSONDecoder().decode(Park.self, from: data)
                    let parksArray = parkResponse.data
                    
                    if parksArray.isEmpty {
                        // Display a message in the UI when no data is available
                        DispatchQueue.main.async {
                            // Update your UI elements here, e.g., show an error message
                            print("No parks found for the given search term.")
                            // Update your UI accordingly
                            completion([])
                        }
                    } else {
                        // Data is available, pass the parksArray to the completion handler
                        completion(parksArray)
                    }
                } catch {
                    // Handle decoding errors
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
            // Start the URLSession data task
            task.resume()
        }
    }


    
    
    
    //MARK: - Fetch weather from Weather.gov
    
    func fetchWeatherAPI(completion: @escaping ([Periods]?) -> Void) {
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
                    completion(nil)
                     return
                 }
                 
                 // Ensure data is returned from the API
                 guard let data = data else {
                     print("No data returned from API.")
                    completion(nil)
                     return
                 }
                 
                 do {
                     // Decode the JSON data into a WeatherData object
                     let weatherResponse = try JSONDecoder().decode(WeatherData.self, from: data)
                     
                     // Update the weatherArray property with the results
                    let weatherArray = weatherResponse.properties?.periods ?? []
                    completion(weatherArray)
                    } catch {
                     // Handle any decoding errors
                     print(error.localizedDescription)
                        completion(nil)
                 }
             }
             
             // Start the URLSession data task
             task.resume()
    }
}


