//
//  CurrentDayForecastViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class CurrentDayForecastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Gradient.addBackgroundColor(to: view, gradientName: Gradient.GradientNames.background)
    }
}
