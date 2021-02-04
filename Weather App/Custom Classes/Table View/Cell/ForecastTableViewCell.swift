//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 28.01.21.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
//    func configure(with futureWeather: FutureWeather) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        let timeLabelText = formatter.string(from: futureWeather.date)
//        timeLabel.text = timeLabelText
//
//        conditionLabel.text = futureWeather.conditionDescription.capitalized
//
//        var temperature = futureWeather.temperature.rounded()
//        if (futureWeather.temperature > -1 && futureWeather.temperature < 0) {
//            temperature *= -1
//        }
//        temperatureLabel.text = String(describing: temperature).split(separator: ".")[0] + "℃"
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
}
