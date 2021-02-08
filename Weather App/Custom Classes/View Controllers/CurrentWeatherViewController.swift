//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var addMenuView: UIView!
    @IBOutlet var addMenuTextField: UITextField!
    @IBOutlet var addMenuAddButton: UIView!
    @IBOutlet var addMenuLoader: UIActivityIndicatorView!
    @IBOutlet var addMenuConstraint: NSLayoutConstraint!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    
    private final let addedCitiesKey = "added.cities"
    private let backgroundGradient = Gradient(gradientName: .background)
    private let addMenuGradient = Gradient(gradientName: .green)
    private let blurredEffectView = UIVisualEffectView()
    private let currentWeatherService = Service<CurrentWeatherResponse>()
    private let locationManager = CLLocationManager()
    private var currentWeather: CurrentWeatherResponse? = nil
    private var addedCities: [String] = []
    private var locationFound = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addedCities = (UserDefaults.standard.array(forKey: addedCitiesKey) as? [String]) ?? []
        ActiveCity.shared.name = (addedCities.count > 0) ? addedCities[0] : nil
        
        errorView.reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        blurredEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (closeAddMenu)))
        
        pageControl.numberOfPages = addedCities.count
        
        addGradients()
        addGlows()
        
        initCLLocation()
        loadCurrentWeather()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addRoundedCorners()
        updateGradientFrames()
        updateGlowPaths()
        blurredEffectView.frame = view.bounds
    }
    
    @IBAction func refresh() {
        loadCurrentWeather()
        closeAddMenu()
    }
    
    @IBAction func openAddMenu() {
        addBlur()
        animateAddMenu(to: 0, over: 0.5)
    }
    
    @objc func closeAddMenu() {
        animateAddMenu(to: -700, over: 0.5)
        removeBlur()
    }
    
    @IBAction func handleAddingCity() {
        let cityName = addMenuTextField.text ?? ""
        addMenuTextField.text = ""
        addMenuAddButton.tintColor = .clear
        addMenuLoader.startAnimating()
        addCity(cityName: cityName, wasFoundWithGPS: false)
    }
    
    @IBAction func changeActiveCity() {
        let pageControlCurrentPage = pageControl.currentPage
        if (ActiveCity.shared.name != addedCities[pageControlCurrentPage]) {
            ActiveCity.shared.name = addedCities[pageControlCurrentPage]
        }
    }
    
    private func loadCurrentWeather() {
        let activeCity = ActiveCity.shared.name ?? ""
        DispatchQueue.main.async {
            self.mainContainerView.isHidden = true
            self.errorView.isHidden = true
            self.loader.startAnimating()
        }
        
        currentWeatherService.getServiceResult(for: activeCity, at: nil) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                self.mainContainerView.isHidden = false //TODO: Here for now
                switch result {
                case .success(let currentWeatherResult):
                    self.currentWeather = currentWeatherResult
                case .failure(let error):
                    if (ServiceError.keyNotFound != error as? ServiceError) {
                    }
                    self.mainContainerView.isHidden = false
                }
            }
        }
    }
    
    private func addCity(cityName: String, wasFoundWithGPS: Bool) {
        currentWeatherService.getServiceResult(for: cityName, at: nil) { result in
            switch result {
            case .success(let currentWeatherResult):
                if (self.addedCities.contains(currentWeatherResult.name.lowercased())) {
                    self.showErrorPopup(errorMessage: "City already added")
                } else if (self.addedCities.count == 3) {
                    self.showErrorPopup(errorMessage: "Maximum numbers of 3 cities reached. Remove already added city if you want to add more")
                } else {
                    if (wasFoundWithGPS) {
                        self.addedCities.insert(currentWeatherResult.name.lowercased(), at: 0)
                    } else {
                        self.addedCities.append(currentWeatherResult.name.lowercased())
                    }
                    ActiveCity.shared.name = currentWeatherResult.name.lowercased()
                    UserDefaults.standard.set(self.addedCities, forKey: self.addedCitiesKey)
                    self.loadCurrentWeather()
                    DispatchQueue.main.async {
                        self.pageControl.numberOfPages += 1
                        if (wasFoundWithGPS) {
                            self.pageControl.currentPage = 0
                        } else {
                            self.addMenuLoader.stopAnimating()
                            self.addMenuAddButton.tintColor = UIColor(named: "green-gradient-end")
                            self.closeAddMenu()
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
    
    private func addGradients() {
        backgroundGradient.addBackgroundColor(to: view)
        addMenuGradient.addBackgroundColor(to: addMenuView)
    }
    
    private func updateGradientFrames() {
        backgroundGradient.updateFrameBounds(to: view.bounds)
        addMenuGradient.updateFrameBounds(to: addMenuView.bounds)
    }
    
    private func addGlows() {
        Glow.addGlow(to: addButton)
        Glow.addGlow(to: addMenuAddButton)
    }
    
    private func updateGlowPaths() {
        Glow.updateGlowPath(of: addButton)
        Glow.updateGlowPath(of: addMenuAddButton)
    }
    
    private func addRoundedCorners() {
        makeCornersRounded(for: addButton.layer, factor: 0.5)
        makeCornersRounded(for: addMenuAddButton.layer, factor: 0.5)
        makeCornersRounded(for: addMenuView.layer, factor: 0.1)
    }
    
    private func makeCornersRounded(for layer: CALayer, factor: CGFloat) {
        layer.cornerRadius = layer.frame.width * factor
    }
    
    private func animateAddMenu(to constraintConstant: CGFloat, over time: TimeInterval) {
        UIView.animate(withDuration: time,
                       animations: { [self] in
                        addMenuConstraint.constant = constraintConstant
                        view.layoutIfNeeded()
        })
    }
    
    private func addBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurredEffectView.effect = blurEffect
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
        addMenuView.superview?.bringSubviewToFront(addMenuView)
    }
    
    private func removeBlur() {
        blurredEffectView.removeFromSuperview()
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
                        self.addCity(cityName: currentWeatherResult.name, wasFoundWithGPS: true)
                        self.locationFound = true
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}
