//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet var field: UITextField!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    
    private final let addedCitiesKey = "added.cities"
    private let gradient = Gradient(gradientName: .background)
    private let currentWeatherService = Service<CurrentWeatherResponse>()
    private let locationManager = CLLocationManager()
    private var currentWeather: CurrentWeatherResponse? = nil
    private var addedCities: [String] = []
    private var locationFound = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(ActiveCity.shared.name ?? "")
        print(UserDefaults.standard.array(forKey: "added.cities") ?? "")
//                UserDefaults.standard.removeObject(forKey: "added.cities")
//                return
        
        initCLLocation()
        addedCities = (UserDefaults.standard.array(forKey: addedCitiesKey) as? [String]) ?? []
        gradient.addBackgroundColor(to: view)
        ActiveCity.shared.name = (addedCities.count > 0) ? addedCities[0] : nil
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
    
    @IBAction func handleAddingCity() {
        let cityName = field.text!
        addCity(cityName: cityName, isFoundLocation: false)
    }
    
    @IBAction func changeActiveCity() {
        let pageControlCurrentPage = pageControl.currentPage
        if (ActiveCity.shared.name != addedCities[pageControlCurrentPage]) {
            ActiveCity.shared.name = addedCities[pageControlCurrentPage]
        }
    }
    
    private func loadCurrentWeather() {
        //TODO: Hide other staff
        let activeCity = ActiveCity.shared.name ?? ""
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.loader.startAnimating()
        }
        
        currentWeatherService.getServiceResult(for: activeCity, at: nil) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                switch result {
                case .success(let currentWeatherResult):
                    self.currentWeather = currentWeatherResult
                case .failure(let error):
                    if (ServiceError.keyNotFound != error as? ServiceError) {
                        self.errorView.isHidden = false
                    }
                }
            }
        }
    }
    
    private func addCity(cityName: String, isFoundLocation: Bool) {
        currentWeatherService.getServiceResult(for: cityName, at: nil) { result in
            switch result {
            case .success(let currentWeatherResult):
                if (self.addedCities.contains(currentWeatherResult.name.lowercased())) {
                    self.showErrorPopup(errorMessage: "City already added")
                } else if (self.addedCities.count == 3) {
                    self.showErrorPopup(errorMessage: "Maximum numbers of 3 cities reached. Remove already added city if you want to add more")
                } else {
                    if (isFoundLocation) {
                        self.addedCities.insert(currentWeatherResult.name.lowercased(), at: 0)
                    } else {
                        self.addedCities.append(currentWeatherResult.name.lowercased())
                    }
                    ActiveCity.shared.name = currentWeatherResult.name.lowercased()
                    UserDefaults.standard.set(self.addedCities, forKey: self.addedCitiesKey)
                    self.loadCurrentWeather()
                    DispatchQueue.main.async {
                        self.pageControl.numberOfPages += 1
                        if (isFoundLocation) {
                            self.pageControl.currentPage = 0
                        } else {
                            self.pageControl.currentPage = self.pageControl.numberOfPages
                        }
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
    
    private func initCLLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
}

extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if (!locationFound) {
            currentWeatherService.getServiceResult(for: nil, at: coordinate) { result in
                switch result {
                case .success(let currentWeatherResult):
                    if (!self.addedCities.contains(currentWeatherResult.name.lowercased())) {
                        self.addCity(cityName: currentWeatherResult.name, isFoundLocation: true)
                        self.locationFound = true
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}
