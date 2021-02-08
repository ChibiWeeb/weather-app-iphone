//
//  ActiveCity.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 07.02.21.
//

import Foundation

class ActiveCity {
    
    static let shared = ActiveCity()
    
    var name: String?
    
    private init() {}
}
