//
//  WeatherManager.swift
//  Clima
//
//  Created by Nina Paripovic on 4/2/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    func didWeatherUpdate (_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let WeatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=a2f95b7668bc540f4890a50308af1087&units=metric"
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(WeatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(WeatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // create URL
        
        if let url = URL(string: urlString) {
            // create URL session
            let session = URLSession(configuration: .default)
            
            // give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didWeatherUpdate(self, weather: weather)
                    }
                }
            }
            
            // start the task
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let iconID = decodedData.weather[0].id
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            let weather = WeatherModel(conditionID: iconID, cityName: cityName, temp: temp)
            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    } 
}
