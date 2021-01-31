//
//  TodaysWeather+CoreDataProperties.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 31.01.21.
//
//

import Foundation
import CoreData


extension TodaysWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodaysWeather> {
        return NSFetchRequest<TodaysWeather>(entityName: "TodaysWeather")
    }

    @NSManaged public var temperature: Double
    @NSManaged public var conditionMain: String?
    @NSManaged public var cloudiness: Int16
    @NSManaged public var humidity: Int16
    @NSManaged public var windSpeed: Double
    @NSManaged public var windDegrees: Int16
    @NSManaged public var location: Location?

}

extension TodaysWeather : Identifiable {

}
