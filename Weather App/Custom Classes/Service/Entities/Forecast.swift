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
