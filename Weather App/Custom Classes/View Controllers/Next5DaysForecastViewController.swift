//
//  Next5DaysForecastViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class Next5DaysForecastViewController: UIViewController {
    var gradient: Gradient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient = Gradient(gradientName: Gradient.GradientNames.background)
        gradient.addBackgroundColor(to: view)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.updateFrameBounds(to: view.frame)
    }
}
