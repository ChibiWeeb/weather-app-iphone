//
//  Forecast.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 29.01.21.
//

import Foundation

//TODO: Check if everything is needed here

struct ForecastResponse: Codable {
    let list: [Forecast]
    let city: City
}

struct Forecast: Codable {
    let dt: Int
    let main: ForecastMainInfo
    let weather: [ForecastWeatherInfo]
}

struct ForecastMainInfo: Codable {
    let temp: Double
}

struct ForecastWeatherInfo: Codable {
    let description: String
    let icon: String
}

struct City: Codable {
    let id: Int
    let name: String
    let country: String
}
