//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 28.01.21.
//

import UIKit
import SDWebImage

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    private var components = URLComponents()
    
    func configure(with forecast: Forecast) {
        components.scheme = "https"
        components.host = "openweathermap.org"
        components.path = ("/img/wn/" + forecast.weather[0].icon + ".png")
        iconImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        iconImageView.sd_setImage(with: components.url)
        
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
