//
//  Forecast.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 29.01.21.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [Forecast]
    let city: City
}

struct Forecast: Codable {
    let dt: Int
    let main: MainInfo
    let weather: [Weather]
}

struct MainInfo: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct City: Codable {
    let id: Int32
    let name: String
    let country: String
}
