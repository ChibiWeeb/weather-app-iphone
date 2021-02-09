//
//  CurrentWeatherCell.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 08.02.21.
//

import UIKit

class CurrentWeatherCell: UICollectionViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var cityAndCountryLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var cloudinessLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!

    private var gradient: Gradient? = nil
    
    //TODO: Use reusable view for bottom views
    func configure(with currentWeather: CurrentWeatherResponse, at index: Int) {
        switch index {
        case 0:
            cellView.backgroundColor = UIColor(named: "green-gradient-start")
            gradient = Gradient(gradientName: .green)
        case 1:
            cellView.backgroundColor = UIColor(named: "blue-gradient-start")
            gradient = Gradient(gradientName: .blue)
        case 2:
            cellView.backgroundColor = UIColor(named: "ochre-gradient-start")
            gradient = Gradient(gradientName: .ochre)
        default:
            break
        }
        if (gradient != nil) {
            gradient?.addBackgroundColor(to: cellView)
            Glow.addGlow(to: cellView)
        }
        
        cityAndCountryLabel.text = currentWeather.sys.country + "," + currentWeather.name
        
        var temperature = currentWeather.main.temp.rounded()
        if (currentWeather.main.temp > -1 && currentWeather.main.temp < 0) {
            temperature *= -1
        }
        temperatureLabel.text = String(describing: temperature).split(separator: ".")[0] + "℃"
        
        conditionLabel.text = currentWeather.weather[0].main.capitalized
        
        cloudinessLabel.text = String(describing: currentWeather.clouds.all) + " %"
        
        humidityLabel.text = String(describing: currentWeather.main.humidity) + " mm"
        
        windSpeedLabel.text = String(describing: currentWeather.wind.speed * 3.6) + " km/h"
        
        windDirectionLabel.text = windDirectionFromDegrees(degrees: Double(currentWeather.wind.deg))
    }
    
    private func windDirectionFromDegrees(degrees : Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i: Int = Int((degrees + 11.25)/22.5)
        return directions[i % 16]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        cellView.layer.cornerRadius = cellView.layer.frame.width * 0.1
        if (gradient != nil) {
            gradient?.updateFrameBounds(to: cellView.bounds)
            Glow.updateGlowPath(of: cellView)
        }
    }

}
