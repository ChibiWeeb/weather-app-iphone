//
//  ForecastTableViewHeader.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 05.02.21.
//

import UIKit

class ForecastTableViewHeader: UITableViewHeaderFooterView {
    
    @IBOutlet var dayLabel: UILabel!
    
    func setDayLabelText(as day: String) {
        dayLabel.text = day
    }
}
