//
//  SearchBarManager.swift
//  HikeHaven
//
//  Created by Diana Duong on 10/6/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

class SearchBarManager: NSObject, UISearchBarDelegate {
    let searchBar: UISearchBar
    var searchTerm: String = "hiking"
    
    init(searchBar: UISearchBar) {
        self.searchBar = searchBar
        super.init()
        
        searchBar.delegate = self
        configureSearchBar()
    }
    
    func configureSearchBar() {
        searchBar.searchBarStyle = .default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerm = searchText
        // Call a delegate method or closure to notify the parent view controller about text changes if needed.
       
    }
}


