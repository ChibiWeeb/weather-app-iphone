//
//  Glow.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 06.02.21.
//

import UIKit

class Glow {
    
    static func setGlow(to view: UIView) {
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = UIColor(named: "accent")?.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
}
