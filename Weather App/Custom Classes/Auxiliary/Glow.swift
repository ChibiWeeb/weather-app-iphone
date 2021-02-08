//
//  Glow.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 06.02.21.
//

import UIKit

class Glow {
    
    static func addGlow(to view: UIView) {
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = view.backgroundColor?.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    static func updateGlowPath(of view: UIView) {
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
}
