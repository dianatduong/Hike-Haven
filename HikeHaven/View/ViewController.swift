//
//  ViewController.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    //API
    var unsplashArray: [UnSplashData] = []
    var parksArray: [ParkData] = []
    var weatherArray: [Periods] = []
        
    var headerView: HeaderView!
    
    var searchTerm: String = "Alaska"
    
    let stateCodes = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
        "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
        "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
        "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
        "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
    ]
    
    var selectedStateCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNav()
        setupHeader()
        
        // Configure the table view using the TableViewManager
        TableViewManager.configureTableView(for: tableView, withDelegate: self)
        
        //fetching API data
        fetchDataAPI()
        fetchImagesAPI()
        fetchWeatherAPI()
    }
    
    func setUpNav() {
        self.navigationItem.title = "Hike Haven"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Home"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setupHeader() {
        headerView = HeaderView()
        
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame.size.height = 120
        
        headerView.stateCodePicker.delegate = self
        headerView.stateCodePicker.dataSource = self
        
        headerView.setTitle("Explore Hiking Trails")
        headerView.textField.placeholder = "Select a state"
    }
    
    
    //MARK: -  Fetching APIs
    
    func fetchImagesAPI() {
        APIManager.shared.fetchImagesAPI(searchTerm: searchTerm) { [weak self] unsplashArray in
            guard let self = self, let unsplashArray = unsplashArray else {
                return
            }
            self.unsplashArray = unsplashArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataAPI() {
        APIManager.shared.fetchDataAPI(searchTerm: searchTerm) { [weak self] parksArray in
            guard let self = self, let parksArray = parksArray else {
                return
            }
            self.parksArray = parksArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchWeatherAPI() {
        APIManager.shared.fetchWeatherAPI { [weak self] weatherArray in
            guard let self = self, let weatherArray = weatherArray else {
                return
            }
            self.weatherArray = weatherArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    //MARK: - TableViews
    
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
                APIManager.shared.loadImage(from: imageURL) { image in
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
        let park = parksArray[indexPath.row]
        let unsplashData = unsplashArray[indexPath.row]
        //let weather = weatherArray[indexPath.row]
        
        // Create instances of both view controllers
        let detailsVC = DetailsViewController()
        
        // Pass data to DetailsViewController
        detailsVC.selectedPark = park
        detailsVC.selectedUnsplashData = unsplashData
        // detailsVC.selectedWeatherData = weather
        
        // Push the DetailsViewController onto the navigation stack
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
 // MARK: UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateCodes.count
        
    }
    
    // MARK: UIPickerViewDelegate methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateCodes[row]
    }
    
 func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedStateCode = stateCodes[row]
        
        // Update the text field with the selected state code
        headerView.textField.text = selectedStateCode
        
        // Update the search term based on the selected state code
        searchTerm = "\(selectedStateCode)" // Modify this as needed
        
        // Close the picker
        headerView.textField.resignFirstResponder()
        
        // Fetch data with the updated search term
        fetchDataAPI()
        fetchImagesAPI()
        //fetchWeatherAPI()
    }
}


