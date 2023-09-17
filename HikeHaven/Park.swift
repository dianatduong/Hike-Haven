//
//  ParkData.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/13/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

     struct Park: Codable {
            let data: [ParkData]
        }

        struct ParkData: Codable {
            let fullName: String?
            let addresses: [Addresses]?
            let description: String?
            let operatingHours: [OperatingHours]?
            let parkCode: String?
            // let directionsInfo: String?
            //  let weatherInfo: String?
        }

        struct Addresses: Codable {
            let line1: String
            let line2: String
            let city: String
            let stateCode: String
            let postalCode: String
        }

        struct OperatingHours: Codable {
            //let name: String
            //let description: String
            let standardHours: StandardHours?
            let exceptions: [ExceptionHours?]
        }

            struct StandardHours: Codable {
                let sunday: String
                let monday: String
                let tuesday: String
                let wednesday: String
                let thursday: String
                let friday: String
                let saturday: String
            }

            struct ExceptionHours: Codable {
                let name: String?
                // let startDate: String
                // let endDate: String
                // let exceptionHours: [ExceptionHours]
            }

     


    /*
 
 struct Contact: Codable {
          let phoneNumbers: [PhoneNumber]?
          let emailAddresses: [EmailAddress]?
      }

      struct EmailAddress: Codable {
          let emailAddress: String?
      }

      struct PhoneNumber: Codable {
          let phoneNumber: String?
      }
     
     
     struct ExceptionHours: Codable {
         let sunday: String
         let monday: String
         let tuesday: String
         let wednesday: String
         let thursday: String
         let friday: String
         let saturday: String
     }
     
     
     // let images: [Image]?
      //let amenities: TrailsAmenities? - not enough data
      // let contacts: [Contact] - not working
     
     NOT ENOUGH DATA
     struct TrailsAmenities: Codable {
         let internetconnectivity: Bool
         let cellphonereception: Bool
         let stafforvolunteerhostonsite: String
     }
     
     struct Image: Codable {
         let title: String
         let id: Int
         let caption: String
         let url: String
     }
     
     DOESN'T WORK
     struct Contact: Codable {
         let phoneNumbers: [PhoneNumber]
         let emailAddresses: [EmailAddress]
     }

     struct EmailAddress: Codable {
         let emailAddress: String
     }
     
     struct PhoneNumber: Codable {
         let phoneNumber, description, phoneNumberExtension, type: String

         enum CodingKeys: String, CodingKey {
             case phoneNumber, description
             case phoneNumberExtension = "extension"
             case type
         }
     }
     */




     
     
