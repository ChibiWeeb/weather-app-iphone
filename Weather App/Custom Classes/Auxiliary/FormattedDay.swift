//
//  FormattedDay.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 05.02.21.
//

import Foundation

class FormattedDay {
    
    private let timeInterval: TimeInterval
    private let dateFormat: DateFormat
    
    init(timeInterval: TimeInterval, dateFormat: DateFormat) {
        self.timeInterval = timeInterval
        self.dateFormat = dateFormat
    }
    
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.rawValue
        return formatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }
    
    enum DateFormat: String {
        case hoursAndMinutes = "HH:mm"
        case day = "EEEE"
    }
}
