//
//  TabBarController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make tab bar transparent
        tabBar.barTintColor = .clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        //Make unselected tab bar items white
        tabBar.unselectedItemTintColor = .white
    }


}
