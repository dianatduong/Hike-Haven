//
//  APIManager.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import Foundation

class APIManager {
    let dispatchGroup = DispatchGroup()
    var unsplashArray: [UnSplashStruct] = []
    var parksArray: [Park] = []
    
    func fetchAllData() {
        dispatchGroup.enter()
        fetchImagesAPI()
        
        dispatchGroup.enter()
        fetchDataAPI()
        
        dispatchGroup.notify(queue: .main) {
            // Reload your table view here
        }
    }
    
    func fetchImagesAPI() {
        let searchTerm = "zion"
        let url = URL(string: "https://api.unsplash.com/search/photos?client_id=SwsdyqI6m6t38pMRrT8uCyXd-6-AKdT5Dy8I76IpEtc&count=1&query=\(searchTerm)&per_page=20&orientation=landscape&order_by=popular")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = Double.infinity
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                self.dispatchGroup.leave()
                return
            }
            guard let data = data else {
                print("No data returned from API.")
                self.dispatchGroup.leave()
                return
            }
            do {
                let parkResponse = try JSONDecoder().decode(UnSplashStruct.self, from: data)
                self.unsplashArray = parkResponse.results
                self.dispatchGroup.leave()
            } catch {
                print(error.localizedDescription)
                self.dispatchGroup.leave()
            }
        }
        task.resume()
    }
    
    func fetchDataAPI() {
        let searchTerm = "mn"
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?limit=20&stateCode=\(searchTerm)")!
        var request = URLRequest(url: url)
        request.addValue("WKsNM1QPZ90IJLcgF7zsufYJQh8nCyACrTtoEABo", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                self.dispatchGroup.leave()
                return
            }
            guard let data = data else {
                print("No data returned from API.")
                self.dispatchGroup.leave()
                return
            }
            do {
                let parkResponse = try JSONDecoder().decode(Park.self, from: data)
                self.parksArray = parkResponse.data
                self.dispatchGroup.leave()
            } catch {
                print(error.localizedDescription)
                self.dispatchGroup.leave()
            }
        }
        task.resume()
    }
}
