//
//  ViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UITableViewController, UISearchBarDelegate {
    
    var searchBar: UISearchBar = UISearchBar()
    var searchTerm: String = "hiking"
    
    let headerView = UIView()

    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Popular Trails"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    var unsplashArray: [UnSplashData] = []
    var parksArray: [ParkData] = []
    var weatherArray: [Periods] = []

    
    let imageCache = NSCache<NSString, UIImage>()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        navigationItem.title = "Hike Haven"
        setUpHeader()
        configureTableView()
        fetchDataAPI()
        fetchImagesAPI()

    }
    
    func configureSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerm = searchText
        fetchDataAPI()
        fetchImagesAPI()
    }

    func setUpHeader() {
        headerView.addSubview(headerTitle)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = 65
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            headerTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20)
        ])
    }
    
    func configureTableView() {
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 320
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
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

    func fetchImagesAPI() {
        let url = URL(string: "https://api.unsplash.com/search/photos?client_id=SwsdyqI6m6t38pMRrT8uCyXd-6-AKdT5Dy8I76IpEtc&count=1&query=\(searchTerm)+national+parks&per_page=20&orientation=landscape&order_by=popular")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = Double.infinity

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
              let parkResponse = try JSONDecoder().decode(UnSplashStruct.self, from: data)
                self.unsplashArray = parkResponse.results
             
              DispatchQueue.main.async {
                self.tableView.reloadData()
              }
            } catch {
              print(error.localizedDescription)
            }
          }
          task.resume()
    }

    func fetchDataAPI() {
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
                self.parksArray = parkResponse.data
                
                // Print the results to the console
                print(parkResponse.data)
                
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

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parksArray.count
    }
      
      

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell {
            
            let park = parksArray[indexPath.row]
            let unsplashData = unsplashArray[indexPath.row]
            
            cell.nameLabel.text = park.fullName

            //unwrap [Addresses]
            if let addresses = park.addresses, let firstAddress = addresses.first {
              let address = "\(firstAddress.line1)"
              let city = "\(firstAddress.city), "
               let state =  "\(firstAddress.stateCode) "
              let postalCode = "\(firstAddress.postalCode)"
                  cell.addressLabel.text = address
                  cell.cityLabel.text = city
                  cell.stateLabel.text = state
                  cell.postCodeLabel.text = postalCode
            }
            
            //unwrap urls: ImageURLS
            if let imageURLString = unsplashData.urls.regular,
               let imageURL = URL(string: imageURLString) {
               loadImage(from: imageURL) { image in
                   DispatchQueue.main.async {
                       cell.mainImageView.image = image
                   }
               }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let secondVC = DetailsViewController()
         let accordionVC = AccordionViewController()
         
         let park = parksArray[indexPath.row]
         let unsplashData = unsplashArray[indexPath.row]
         
         // Pass the data to AccordionViewController
         accordionVC.parksArray = parksArray
         accordionVC.weatherArray = weatherArray
         
         secondVC.accordionVC = accordionVC
         
         self.navigationController?.pushViewController(secondVC, animated: true)
           
           //unwrap urls: ImageURLS
            if let imageURLString = unsplashData.urls.regular,
                let imageURL = URL(string: imageURLString) {
                    loadImage(from: imageURL) { image in
                        DispatchQueue.main.async {
                           secondVC.selectedImageView.image = image
                           secondVC.selectedNameLabel.text = park.fullName
                           secondVC.trailDescriptionLabel.text = park.description
                        }
                    }
                }
        
        //unwrap [Addresses]
        if let addresses = park.addresses, !addresses.isEmpty {
             if let firstAddress = addresses.first {
                 let address = "\(firstAddress.line1)"
                 let city = "\(firstAddress.city), "
                  let state =  "\(firstAddress.stateCode) "
                 let postalCode = "\(firstAddress.postalCode)"

                 secondVC.trailAddressLabel.text = address
                 secondVC.trailCityLabel.text = city
                 secondVC.trailStateLabel.text = state
                 secondVC.trailZipCodeLabel.text = postalCode
             }
         } else {
             // Handle the case where park.addresses is nil or empty
             secondVC.trailAddressLabel.text = "Address not available"
             secondVC.trailCityLabel.text = "City not available"
             secondVC.trailStateLabel.text = "State not available"
             secondVC.trailZipCodeLabel.text = "Postal code not available"
         }
    }
}

