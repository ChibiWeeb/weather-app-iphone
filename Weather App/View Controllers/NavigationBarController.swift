//
//  NavigationBarController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class NavigationBarController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTabBarAppearance()
    }

    func changeTabBarAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBarAppearance.titleTextAttributes = titleTextAttributes
        
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.compactAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }

}
