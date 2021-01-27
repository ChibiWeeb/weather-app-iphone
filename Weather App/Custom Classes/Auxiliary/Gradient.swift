//
//  Gradient.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 28.01.21.
//

import UIKit

class Gradient {
    private let gradientLayer: CAGradientLayer
    
    
    private init(gradientName: GradientNames, frameBounds: CGRect) {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientName.gradientColors
        gradientLayer.frame = frameBounds
    }
    
    static func addBackgroundColor(to view: UIView, gradientName:GradientNames) {
        let gradientLayer = Gradient(gradientName: gradientName,frameBounds: view.bounds).gradientLayer
        view.layer.insertSublayer(gradientLayer, at: 0)
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
