//
//  CurrentDayForecastViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class CurrentDayForecastViewController: UIViewController {
    
    private let gradient = Gradient(gradientName: Gradient.GradientNames.background)
    private let currentWeatherService = Service<CurrentWeatherResponse>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.addBackgroundColor(to: view)
        
        //TODO: Temporary
//        currentWeatherService.getCurrentWeather(for: "Tbilisi")
        currentWeatherService.getService(for: "Tbilisi")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.updateFrameBounds(to: view.frame)
    }
}
