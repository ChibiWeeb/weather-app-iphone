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
        
        addBackgroundColor()
    }

    func addBackgroundColor() {
        let gradientLayer = Gradient(
            gradientName: Gradient.GradientNames.background,
            frameBounds: view.bounds
        ).getGradientLayer()
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
