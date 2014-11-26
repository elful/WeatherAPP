//
//  Weather.swift
//  Weather
//
//  Created by elf on 11/18/14.
//  Copyright (c) 2014 elf. All rights reserved.
//

import Foundation
import UIKit

struct Weather {
    var currentTime: String?
    
    var humidity: Double
    var precipProbability: Double
    var summary: String
    var icon: UIImage?
    var location: String
    var temperature: Int
    
    init(weatherDictionary: NSDictionary){
        let currentWeather = weatherDictionary["currently"] as NSDictionary
        temperature = currentWeather["temperature"] as Int
        humidity = currentWeather["humidity"] as Double
        precipProbability = currentWeather["precipProbability"] as Double
        summary = currentWeather["summary"] as String
        location = "location"
        icon = weatherIconFromString(currentWeather["icon"] as String)
        currentTime = dateStringFromUnixTime(currentWeather["time"] as Int)
        let fahrenheit = currentWeather["temperature"] as Int
        temperature = convertToCelsius(fahrenheit)
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
    
    
    func dateStringFromUnixTime(unixTime: Int) -> String{
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName: String
        
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        return UIImage(named: imageName)!
}

}
