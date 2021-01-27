//
//  NavigationButtonBarItem.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 28.01.21.
//

import UIKit

class NavigationButtonBarItem: UIBarButtonItem {
    
    //Is this even a proper way of doing it?
    override func awakeFromNib() {
        image = UIImage(systemName: "arrow.clockwise")
        style = .plain
        target = self
        action = #selector(handleRefreshButton)
    }
    
    @objc func handleRefreshButton() {
        print("worksssss")
    }
}
