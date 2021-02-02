//
//  DatabaseManager.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 29.01.21.
//

import Foundation
import CoreData

final class DatabaseManager {
    static var shared = DatabaseManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Weather_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //TODO: Handle errors
    static func addLocation(id: Int32, city: String, country: String, in context: NSManagedObjectContext) {
        let location = Location(context: context)
        location.country = Locale(identifier: "en_US").localizedString(forRegionCode: country)
        location.city = city
        location.id = id
        location.todaysWeather = nil
        location.futureWeathers = []
        
        do {
            try context.save()
        } catch {
            print("Saving Location Failed: \(error)")
        }
    }
    
    //TODO: Temporary
    enum MyError: Error {
        case runtimeError(String)
    }
    
    //TODO: Change search criteria to id
    static func getLocation(for city: String, in context: NSManagedObjectContext) throws -> Location? {
        let fetchRequestPredicate = NSPredicate(format: "city == %@", city)
        let fetchRequest = Location.fetchRequest() as NSFetchRequest<Location>
        fetchRequest.predicate = fetchRequestPredicate
        do {
            let fetchResult = try context.fetch(fetchRequest)
            guard (fetchResult.count > 0) else {
                throw MyError.runtimeError("Fetch result is rmpty")
            }
            return fetchResult[0]
        } catch {
            print("Fetch failed: \(error)")
            throw error
        }
    }
    
    static func updateForecast(with result: ForecastResponse, in context: NSManagedObjectContext) {
        do {
            let location = try getLocation(for: result.city.name, in: context)!
            location.futureWeathers?.removeAll()
            let forecastList = result.list
            for forecast in forecastList {
                let weather = forecast.weather[0]
                let futureWeather = FutureWeather(
                    icon: weather.icon,
                    date: Date(timeIntervalSince1970: TimeInterval(forecast.dt)),
                    conditionDescription: weather.description,
                    temperature: forecast.main.temp
                )
                location.futureWeathers?.append(futureWeather)
            }
        } catch {
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print("Saving future weathers failed: \(error)")
        }
    }
    
    static func updateCurrentWeather(with result: CurrentWeatherResponse, in context: NSManagedObjectContext) {
        do {
            let location = try getLocation(for: result.name, in: context)!
            location.todaysWeather = nil
            let todaysWeather = TodaysWeather(
                temperature: result.main.temp,
                conditionMain: result.weather[0].main,
                cloudiness: result.clouds.all,
                humidity: result.main.humidity,
                windSpeed: result.wind.speed,
                windDirection: TodaysWeather.getWindDirectionFromDegrees(degrees: result.wind.deg)
            )
            location.todaysWeather = todaysWeather
        } catch {
            print(error)
        }
        
        do {
            try context.save()
        } catch {
            print("Saving Current Weather Failed: \(error)")
        }
    }
}