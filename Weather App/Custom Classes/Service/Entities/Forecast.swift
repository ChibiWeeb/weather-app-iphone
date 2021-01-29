//
//  Forecast.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 29.01.21.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let main: MainInfo
    let weather: [Weather]
    let dt_txt: String
    
}

struct MainInfo: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
