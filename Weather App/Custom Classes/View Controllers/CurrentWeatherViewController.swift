//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet var field: UITextField!
    
    private let gradient = Gradient(gradientName: .background)
    private let currentWeatherService = Service<CurrentWeatherResponse>()
    private var currentWeather: CurrentWeatherResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UserDefaults.standard.array(forKey: "added.cities"))
//                UserDefaults.standard.removeObject(forKey: "added.cities")
//                return
        
        gradient.addBackgroundColor(to: view)
        loadCurrentWeather()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.updateFrameBounds(to: view.frame)
    }
    
    private func loadCurrentWeather() {
        guard let addedCities = UserDefaults.standard.array(forKey: "added.cities") else {return}
        print(addedCities)
        guard !addedCities.isEmpty else {return}
        let city = addedCities[addedCities.count - 1]
        
        currentWeatherService.getServiceResult(for: city as! String) { [weak self] result in
            guard let self = self else {return}
            //TODO: main thread maybe?
            switch result {
            case .success(let currentWeatherResult):
                self.currentWeather = currentWeatherResult
                print(self.currentWeather)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func refresh() {
        loadCurrentWeather()
    }
    
    @IBAction func addCity() {
        let cityName = field.text!
        
        currentWeatherService.getServiceResult(for: cityName) { result in
            switch result {
            case .success(let currentWeatherResult):
                var addedCities: [String] = (UserDefaults.standard.array(forKey: "added.cities") ?? []) as! [String]
                
                //TODO: Temporary
                if (addedCities.count == 3) {
                    DispatchQueue.main.async {
                        
                        let alertController = UIAlertController(
                            title: "Error",
                            message:"Maximum numbers of 3 cities reached. Remove already added city if you want to add more",
                            preferredStyle: .alert
                        )
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else if (addedCities.contains(currentWeatherResult.name.lowercased())) {
                    DispatchQueue.main.async {
                        
                        let alertController = UIAlertController(
                            title: "Error",
                            message:"City already added",
                            preferredStyle: .alert
                        )
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    addedCities.append(currentWeatherResult.name.lowercased())
                    UserDefaults.standard.set(addedCities, forKey: "added.cities")
                    self.loadCurrentWeather()
                }
            case .failure(let error):
                //TODO: Temporary
                if (ServiceError.keyNotFound == error as! ServiceError) {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(
                            title: "Error",
                            message:"City not found",
                            preferredStyle: .alert
                        )
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
