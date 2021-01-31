//
//  FutureWeather.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 31.01.21.
//

import Foundation

public class FutureWeather: NSObject, NSCoding {
    
    var icon: String
    var date: Date
    var conditionDescription: String
    var temperature: Double
    
    init(icon: String, date: Date, conditionDescription: String, temperature: Double) {
        self.icon = icon
        self.date = date
        self.conditionDescription = conditionDescription
        self.temperature = temperature
    }
    required public init?(coder: NSCoder) {
        self.icon = coder.decodeObject(forKey: "icon") as! String
        self.date = coder.decodeObject(forKey: "date") as! Date
        self.conditionDescription = coder.decodeObject(forKey: "conditionDescription") as! String
        self.temperature = coder.decodeDouble(forKey: "temperature")
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(icon, forKey: "icon")
        coder.encode(date, forKey: "date")
        coder.encode(conditionDescription, forKey: "conditionDescription")
        coder.encode(temperature, forKey: "temperature")
    }
}
