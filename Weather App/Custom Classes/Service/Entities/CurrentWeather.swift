//
//  CurrentWeather.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 01.02.21.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    let weather: [CurrentWeatherWeatherInfo]
    let main: CurrentWeatherMainInfo
    let wind: WindInfo
    let clouds: CloudsInfo
    let sys: SysInfo
    let name: String
}

struct CurrentWeatherWeatherInfo: Codable {
    let main: String
}

struct CurrentWeatherMainInfo: Codable {
    let temp: Double
    let humidity: Int
}

struct WindInfo: Codable {
    let speed: Double
    let deg: Int
}

struct CloudsInfo: Codable {
    let all: Int
}

struct SysInfo: Codable {
    let country: String
}
