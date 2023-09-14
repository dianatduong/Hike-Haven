//
//  Images.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

    struct UnSplashStruct: Codable {
        let results: [UnSplashData]
    }


    struct UnSplashData: Codable {
        //let description: String?
        let urls: ImageURLS
        
    }

    struct ImageURLS: Codable {
        let full: String?
    }
