//
//  Gradient.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 28.01.21.
//

import UIKit

class Gradient {
    
    private let gradientLayer: CAGradientLayer
    
    init(gradientName: GradientNames) {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientName.gradientColors
    }
    
    func addBackgroundColor(to view: UIView) {
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func updateFrameBounds(to newFrameBounds: CGRect) {
        gradientLayer.frame = newFrameBounds
    }
    
    enum GradientNames {
        case background
        case blue
        case green
        case ochre
        
        var gradientColors: [CGColor] {
            switch self {
            case .background:
                return [
                    UIColor(named: "bg-gradient-start")!.cgColor,
                    UIColor(named: "bg-gradient-end")!.cgColor
                ]
            case .blue:
                return [
                    UIColor(named: "blue-gradient-start")!.cgColor,
                    UIColor(named: "blue-gradient-end")!.cgColor
                ]
            case .green:
                return [
                    UIColor(named: "green-gradient-start")!.cgColor,
                    UIColor(named: "green-gradient-end")!.cgColor
                ]
            case .ochre:
                return [
                    UIColor(named: "ochre-gradient-start")!.cgColor,
                    UIColor(named: "ochre-gradient-end")!.cgColor
                ]
            }
        }
    }
}
