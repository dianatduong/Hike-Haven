//
//  ViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let headerView = UIView()

    lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Popular Trails"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    let dispatchGroup = DispatchGroup()
    var unsplashArray: [UnSplashData] = []
    var parksArray: [ParkData] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Hike Haven"
        setUpHeader()
        configureTableView()
        fetchAllData()
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
    
    func fetchAllData() {
        dispatchGroup.enter()
        fetchImagesAPI()
        
        dispatchGroup.enter()
        fetchDataAPI()
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
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
              let cityState = "\(firstAddress.city), \(firstAddress.stateCode) \(firstAddress.postalCode)"
              cell.addressLabel.text = address
              cell.cityLabel.text = cityState
              cell.stateLabel.text = cityState
              cell.postCodeLabel.text = cityState
            }
            
            //unwrap urls: ImageURLS
            if let imageURLString = unsplashData.urls.thumb,
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
                        let imageView = cell.mainImageView
                        imageView.image = UIImage(data: data)
                    }
                }.resume()
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

       let secondVC = DetailsViewController()
       
       let park = parksArray[indexPath.row]
       let unsplashData = unsplashArray[indexPath.row]

       self.navigationController?.pushViewController(secondVC, animated: true)
           
       //unwrap urls: ImageURLS
       if let imageURLString = unsplashData.urls.thumb,
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
                       secondVC.selectedImageView.image = UIImage(data: data)
                       secondVC.selectedNameLabel.text = park.fullName
                       secondVC.trailDescriptionLabel.text = park.description
                   }
               }
               .resume()
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

