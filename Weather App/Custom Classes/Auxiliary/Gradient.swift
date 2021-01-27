//
//  Gradient.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 28.01.21.
//

import UIKit

class Gradient {
    private let gradientLayer: CAGradientLayer
    
    init(gradientName: GradientNames, frameBounds: CGRect) {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientName.gradientColors
        gradientLayer.frame = frameBounds
    }
    
    func getGradientLayer() -> CAGradientLayer {
        return gradientLayer
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
