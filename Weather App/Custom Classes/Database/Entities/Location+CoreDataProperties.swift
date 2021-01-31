//
//  Location+CoreDataProperties.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 31.01.21.
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
    @NSManaged public var todaysWeather: TodaysWeather?
    @NSManaged public var futureWeathers: NSSet?

}

// MARK: Generated accessors for futureWeathers
extension Location {

    @objc(addFutureWeathersObject:)
    @NSManaged public func addToFutureWeathers(_ value: FutureWeather)

    @objc(removeFutureWeathersObject:)
    @NSManaged public func removeFromFutureWeathers(_ value: FutureWeather)

    @objc(addFutureWeathers:)
    @NSManaged public func addToFutureWeathers(_ values: NSSet)

    @objc(removeFutureWeathers:)
    @NSManaged public func removeFromFutureWeathers(_ values: NSSet)

}

extension Location : Identifiable {

}
