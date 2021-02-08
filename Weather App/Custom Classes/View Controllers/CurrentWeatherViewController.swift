//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet var field: UITextField!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    
    private final let addedCitiesKey = "added.cities"
    private let gradient = Gradient(gradientName: .background)
    private let currentWeatherService = Service<CurrentWeatherResponse>()
    private var currentWeather: CurrentWeatherResponse? = nil
    private var addedCities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(ActiveCity.shared.name ?? "")
        print(UserDefaults.standard.array(forKey: "added.cities") ?? "")
        //        UserDefaults.standard.removeObject(forKey: "added.cities")
        //        return
        
        addedCities = (UserDefaults.standard.array(forKey: addedCitiesKey) as? [String]) ?? []
        gradient.addBackgroundColor(to: view)
        setActiveCity()
        errorView.reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        loadCurrentWeather()
        pageControl.numberOfPages = addedCities.count
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.updateFrameBounds(to: view.frame)
    }
    
    @IBAction func refresh() {
        loadCurrentWeather()
    }
    
    @IBAction func addCity() {
        let cityName = field.text!
        
        currentWeatherService.getServiceResult(for: cityName) { result in
            switch result {
            case .success(let currentWeatherResult):
                if (self.addedCities.contains(currentWeatherResult.name.lowercased())) {
                    self.showErrorPopup(errorMessage: "City already added")
                }else if (self.addedCities.count == 3) {
                    self.showErrorPopup(errorMessage: "Maximum numbers of 3 cities reached. Remove already added city if you want to add more")
                } else {
                    self.addedCities.append(currentWeatherResult.name.lowercased())
                    ActiveCity.shared.name = currentWeatherResult.name.lowercased()
                    UserDefaults.standard.set(self.addedCities, forKey: self.addedCitiesKey)
                    self.loadCurrentWeather()
                    DispatchQueue.main.async {
                        self.pageControl.numberOfPages += 1
                        self.pageControl.currentPage = self.pageControl.numberOfPages
                    }
                }
            case .failure(let error):
                if (ServiceError.keyNotFound == error as? ServiceError) {
                    self.showErrorPopup(errorMessage: "City not found")
                } else {
                    self.showErrorPopup(errorMessage: "Some random error happened")
                }
            }
        }
    }
    
    private func setActiveCity() {
        //TODO: Do CLLocation stuff.
        ActiveCity.shared.name = (addedCities.count > 0) ? addedCities[0] : nil
    }
    
    private func loadCurrentWeather() {
        //TODO: Hide other staff
        let activeCity = ActiveCity.shared.name ?? ""
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.loader.startAnimating()
        }
        
        currentWeatherService.getServiceResult(for: activeCity) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                switch result {
                case .success(let currentWeatherResult):
                    self.currentWeather = currentWeatherResult
                    print(self.currentWeather ?? "")
                case .failure(let error):
                    if (ServiceError.keyNotFound == error as? ServiceError) {
                        
                    } else {
                        self.errorView.isHidden = false
                    }
                }
            }
        }
    }
    
    private func showErrorPopup(errorMessage: String) {
        //TODO: Change to actual popup
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: "Error Occured",
                message: errorMessage,
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func changeActiveCity() {
        let pageControlCurrentPage = pageControl.currentPage
        if (ActiveCity.shared.name != addedCities[pageControlCurrentPage]) {
            ActiveCity.shared.name = addedCities[pageControlCurrentPage]
        }
    }
}
