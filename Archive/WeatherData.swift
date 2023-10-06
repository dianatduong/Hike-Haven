//
//  WeatherData.swift
//  HikeHaven
//
//  Created by Diana Duong on 9/14/23.
//  Copyright © 2023 Diana Duong. All rights reserved.
//

import UIKit

struct WeatherData: Codable {
    let properties: Properties?
}

struct Properties: Codable {
    let periods: [Periods]?
}

struct Periods: Codable {
    let temperature: Int?
    let probabilityOfPrecipitation, dewpoint, relativeHumidity: Elevation?
    let windSpeed, windDirection: String?
    let icon: String?
    let shortForecast, detailedForecast: String?
    // let temperatureUnit: TemperatureUnit?
}

struct Elevation: Codable {
    let value: Double?
}

//enum TemperatureUnit: String {
  //  case f
//}

