//
//  TodaysWeather.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 31.01.21.
//

import Foundation

public class TodaysWeather: NSObject, NSCoding {
    
    var temperature: Double
    var conditionMain: String
    var cloudiness: Int
    var humidity: Int
    var windSpeed: Double
    var windDegrees: Int
    
    init(temperature: Double, conditionMain: String, cloudiness: Int, humidity: Int, windSpeed: Double, windDegrees: Int) {
        self.temperature = temperature
        self.conditionMain = conditionMain
        self.cloudiness = cloudiness
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDegrees = windDegrees
    }
    required public init?(coder: NSCoder) {
        self.temperature = coder.decodeDouble(forKey: "temperature")
        self.conditionMain = coder.decodeObject(forKey: "conditionMain") as! String
        self.cloudiness = coder.decodeInteger(forKey: "cloudiness")
        self.humidity = coder.decodeInteger(forKey: "humidity")
        self.windSpeed = coder.decodeDouble(forKey: "windSpeed")
        self.windDegrees = coder.decodeInteger(forKey: "windDegrees")
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(temperature, forKey: "temperature")
        coder.encode(conditionMain, forKey: "conditionMain")
        coder.encode(cloudiness, forKey: "cloudiness")
        coder.encode(humidity, forKey: "humidity")
        coder.encode(windSpeed, forKey: "windSpeed")
        coder.encode(windDegrees, forKey: "windDegrees")
    }
}
