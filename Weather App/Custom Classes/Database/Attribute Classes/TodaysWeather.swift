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
    var windDirection: String
    
    init(temperature: Double, conditionMain: String, cloudiness: Int, humidity: Int, windSpeed: Double, windDirection: String) {
        self.temperature = temperature
        self.conditionMain = conditionMain
        self.cloudiness = cloudiness
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDirection = windDirection
    }
    
    required public init?(coder: NSCoder) {
        self.temperature = coder.decodeDouble(forKey: "temperature")
        self.conditionMain = coder.decodeObject(forKey: "conditionMain") as! String
        self.cloudiness = coder.decodeInteger(forKey: "cloudiness")
        self.humidity = coder.decodeInteger(forKey: "humidity")
        self.windSpeed = coder.decodeDouble(forKey: "windSpeed")
        self.windDirection = coder.decodeObject(forKey: "windDirection") as! String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(temperature, forKey: "temperature")
        coder.encode(conditionMain, forKey: "conditionMain")
        coder.encode(cloudiness, forKey: "cloudiness")
        coder.encode(humidity, forKey: "humidity")
        coder.encode(windSpeed, forKey: "windSpeed")
        coder.encode(windDirection, forKey: "windDirection")
    }
    
    public static func getWindDirectionFromDegrees(degrees: Int) -> String{
        switch degrees {
        case (349...360), (0...11):
            return "N"
        case (12...33):
            return "NNE"
        case (34...56):
            return "NE"
        case (57...78):
            return "ENE"
        case (79...101):
            return "E"
        case (102...123):
            return "ESE"
        case (124...146):
            return "SE"
        case (147...168):
            return "SSE"
        case (169...191):
            return "S"
        case (192...213):
            return "SSW"
        case (214...236):
            return "SW"
        case (237...258):
            return "WSW"
        case (259...281):
            return "W"
        case (282...303):
            return "WNW"
        case (304...326):
            return "NW"
        case (327...348):
            return "NNW"
        default:
            return "ERR"
        }
    }
}
