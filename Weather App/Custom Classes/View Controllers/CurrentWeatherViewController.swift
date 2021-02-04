//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    private let gradient = Gradient(gradientName: .background)
    private let currentWeatherService = Service<CurrentWeatherResponse>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.addBackgroundColor(to: view)
        
//        currentWeatherService.getServiceResult(for: "Tbilisi") { result in
//            switch result {
//            case .success(let currentWeatherResult):
//                print(currentWeatherResult)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.updateFrameBounds(to: view.frame)
    }
}
