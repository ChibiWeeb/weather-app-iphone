//
//  Location+CoreDataProperties.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 01.02.21.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var futureWeathers: [FutureWeather]?
    @NSManaged public var id: Int32
    @NSManaged public var todaysWeather: TodaysWeather?

}

extension Location : Identifiable {

}
