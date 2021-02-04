//
//  Service.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 01.02.21.
//

import Foundation

class Service<T: Codable> {
    
    //TODO: Handle errors
    private let apiKey = "cf270b8b540ec2bbdc4c6aa1093b0653" //TODO: Move into Keychain
    private var components = URLComponents()
    
    init() {
        //TODO: Find a way to avoid duplication
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/"
        
        switch T.self {
        case is CurrentWeatherResponse.Type:
            components.path += "weather"
        case is ForecastResponse.Type:
            components.path += "forecast"
        default:
            print("ha?")
        }
    }
    
    func getService(for city: String) {
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
                        let result = try decoder.decode(T.self, from: data)
                        print(result)
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
