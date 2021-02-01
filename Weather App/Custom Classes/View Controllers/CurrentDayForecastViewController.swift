//
//  CurrentDayForecastViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class CurrentDayForecastViewController: UIViewController {
    
    private var gradient: Gradient!

    private let currentWeatherService = CurrentWeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient = Gradient(gradientName: Gradient.GradientNames.background)
        gradient.addBackgroundColor(to: view)
        
        //TODO: Temporary
//        currentWeatherService.getCurrentWeather(for: "Tbilisi")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.updateFrameBounds(to: view.frame)
    }
}
