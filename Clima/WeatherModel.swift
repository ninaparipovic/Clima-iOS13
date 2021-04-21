//
//  WeatherModel.swift
//  Clima
//
//  Created by Nina Paripovic on 4/9/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temp: Double
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var iconName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...788:
            return "cloud.fog"
        case 800:
            return "sun.min"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}


