//
//  FutureWeather+CoreDataProperties.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 31.01.21.
//
//

import Foundation
import CoreData


extension FutureWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FutureWeather> {
        return NSFetchRequest<FutureWeather>(entityName: "FutureWeather")
    }

    @NSManaged public var icon: String?
    @NSManaged public var date: Date?
    @NSManaged public var conditionDescription: String?
    @NSManaged public var temperature: Double
    @NSManaged public var location: Location?

}

extension FutureWeather : Identifiable {

}
