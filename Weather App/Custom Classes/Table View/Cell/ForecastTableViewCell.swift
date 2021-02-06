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
    
    func configure(with forecast: Forecast) {
        let timeLabelText = FormattedDay(
            timeInterval: TimeInterval(forecast.dt),
            dateFormat: .hoursAndMinutes
        ).getFormattedDate()
        timeLabel.text = timeLabelText

        conditionLabel.text = forecast.weather[0].description.capitalized

        var temperature = forecast.main.temp.rounded()
        if (forecast.main.temp > -1 && forecast.main.temp < 0) {
            temperature *= -1
        }
        temperatureLabel.text = String(describing: temperature).split(separator: ".")[0] + "℃"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
