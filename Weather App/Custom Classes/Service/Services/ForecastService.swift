//
//  ForecastService.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 31.01.21.
//

import Foundation
import CoreData

class ForecastService {
    
    private let apiKey = "cf270b8b540ec2bbdc4c6aa1093b0653" //Temporary. Move into Keychain
    private var components = URLComponents()
    private var databaseContext = DatabaseManager.shared.persistentContainer.viewContext
    
    init() {
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
    }
    
    func getForecast(for city: String) {
        let parameters = [
            "q": city,
            "units": "metric",
            "appid": apiKey
        ]
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(ForecastResponse.self, from: data)
                        DatabaseManager.updateForecast(with: result, in: self.databaseContext)
                    } catch {
                        print(error)
                    }
                } else {
                    print("No Data")
                }
            })
            task.resume()
        } else {
            print("Invalid Parameters")
        }
    }
}
