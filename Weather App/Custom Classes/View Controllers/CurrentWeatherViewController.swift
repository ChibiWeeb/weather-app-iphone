//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit
import CoreLocation
import UPCarouselFlowLayout

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var currentWeatherCollectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var addErrorView: UIStackView!
    @IBOutlet var addErrorMessage: UILabel!
    @IBOutlet var addMenuView: UIView!
    @IBOutlet var addMenuTextField: UITextField!
    @IBOutlet var addMenuAddButton: UIView!
    @IBOutlet var addMenuLoader: UIActivityIndicatorView!
    @IBOutlet var addMenuConstraint: NSLayoutConstraint!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    
    private final let collectionViewCellName = "CurrentWeatherCell"
    
    private let backgroundGradient = Gradient(gradientName: .background)
    private let addMenuGradient = Gradient(gradientName: .green)
    private let blurredEffectView = UIVisualEffectView()
    private let currentWeatherService = Service<CurrentWeatherResponse>()
    private let locationManager = CLLocationManager()
    private var addedWeathers: [CurrentWeatherResponse] = []
    private var locationFound = false
    private let layout = UPCarouselFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActiveCity.shared.name = (addedWeathers.count > 0) ? addedWeathers[0].name : nil
        
        addMenuTextField.delegate = self
        errorView.reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        blurredEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (closeAddMenu)))
        
        pageControl.numberOfPages = addedWeathers.count
        
        addGradients()
        addGlows()
        
        setupCollectionView()
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
        addMenuTextField.becomeFirstResponder()
    }
    
    @objc func closeAddMenu() {
        addErrorView.isHidden = true
        animateAddMenu(to: -700, over: 0.5)
        removeBlur()
        addMenuTextField.resignFirstResponder()
    }
    
    @IBAction func handleAddingCity() {
        let cityName = addMenuTextField.text ?? ""
        addMenuTextField.text = ""
        addMenuAddButton.tintColor = .clear
        addMenuLoader.startAnimating()
        addCity(cityName: cityName, wasFoundWithGPS: false)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if let indexPath = currentWeatherCollectionView.indexPathForItem(at: gesture.location(in: currentWeatherCollectionView)) {
            if (gesture.state == .began) {
                showDeleteWeatherAlert(forWeatherAt: indexPath)
            }
        }
    }
    
    @IBAction func changeActiveCityWithPageControl() {
        let pageControlCurrentPage = pageControl.currentPage
        currentWeatherCollectionView.scrollToItem(at: IndexPath(row: pageControlCurrentPage, section: 0), at: .centeredHorizontally, animated: true)
        ActiveCity.shared.name = addedWeathers[pageControlCurrentPage].name.lowercased()
    }
    
    private func loadWeatherForAddedCities(addedCities: [String]) {
        for city in addedCities {
            currentWeatherService.getServiceResult(for: city, at: nil) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let currentWeatherResult):
                    let currentWeather = currentWeatherResult
                    self.addedWeathers.append(currentWeather)
                case .failure(_):
                    return
                }
            }
        }
        currentWeatherCollectionView.reloadData()
    }
    
    private func showDeleteWeatherAlert(forWeatherAt indexPath: IndexPath) {
        let weather = addedWeathers[indexPath.row]
        let deleteWeatherAlertController = UIAlertController(
            title: "Remove Location?",
            message: "Location will be removed",
            preferredStyle: .alert
        )
        
        deleteWeatherAlertController.addAction(
            UIAlertAction(title: "Cancel",
                          style: .cancel,
                          handler: nil
            )
        )
        deleteWeatherAlertController.addAction(
            UIAlertAction(title: "Delete",
                          style: .destructive,
                          handler: { [unowned self]  _ in
                            deleteWeather(weather)
                          }
            )
        )
        
        present(deleteWeatherAlertController, animated: true, completion: nil)
    }
    
    private func deleteWeather(_ weather: CurrentWeatherResponse) {
        guard let weatherIndex = self.addedWeathers.lastIndex(of: weather) else {return}
        addedWeathers.remove(at: weatherIndex)
        pageControl.numberOfPages -= 1
        loadCurrentWeather()
    }
    
    private func setupCollectionView() {
        currentWeatherCollectionView.delegate = self
        currentWeatherCollectionView.dataSource = self
        
        currentWeatherCollectionView.register(
            UINib(
                nibName: collectionViewCellName,
                bundle: nil
            ),
            forCellWithReuseIdentifier: collectionViewCellName
        )
        
        currentWeatherCollectionView.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPress(gesture: ))
            )
        )
        
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: -32)
        layout.scrollDirection = .horizontal
        currentWeatherCollectionView.collectionViewLayout = layout
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
                self.mainContainerView.isHidden = false
                switch result {
                case .success(let currentWeatherResult):
                    let currentWeather = currentWeatherResult
                    guard let currentWeatherIndex = self.addedWeathers.lastIndex(of: currentWeather) else {return}
                    self.addedWeathers[currentWeatherIndex] = currentWeather
                    self.currentWeatherCollectionView.reloadData()
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
            DispatchQueue.main.async {
                self.addMenuLoader.stopAnimating()
                self.addMenuAddButton.tintColor = UIColor(named: "green-gradient-end")
            }
            switch result {
            case .success(let currentWeatherResult):
                if (self.addedWeathers.contains(currentWeatherResult)) {
                    self.showErrorPopup(errorMessage: "City already added")
                } else if (self.addedWeathers.count == 3) {
                    self.showErrorPopup(errorMessage: "Maximum numbers of 3 cities reached. Remove already added city if you want to add more")
                } else {
                    if (wasFoundWithGPS) {
                        self.addedWeathers.insert(currentWeatherResult, at: 0)
                    } else {
                        self.addedWeathers.append(currentWeatherResult)
                    }
                    ActiveCity.shared.name = currentWeatherResult.name
                    DispatchQueue.main.async {
                        self.pageControl.numberOfPages += 1
                        if (wasFoundWithGPS) {
                            self.pageControl.currentPage = 0
                        } else {
                            self.closeAddMenu()
                        }
                        self.currentWeatherCollectionView.reloadData()
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
        DispatchQueue.main.async {
            self.addErrorView.isHidden = true
            self.addErrorMessage.text = errorMessage
            self.addErrorView.isHidden = false
            self.addPulseAnimation(view: self.addErrorView)
        }
    }
    
    private func addPulseAnimation(view: UIView) {
        let pulseAnimation = CASpringAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.15
        pulseAnimation.repeatCount = 3
        pulseAnimation.fromValue = 0.98
        pulseAnimation.toValue = 1.02
        pulseAnimation.damping = 0.5
        pulseAnimation.initialVelocity = 0.75
        pulseAnimation.autoreverses = true
        pulseAnimation.isRemovedOnCompletion = false
        view.layer.add(pulseAnimation, forKey: "PulseAnimation")
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
        makeCornersRounded(for: addErrorView.layer, factor: 0.2)
    }
    
    private func makeCornersRounded(for layer: CALayer, factor: CGFloat) {
        layer.cornerRadius = layer.frame.height * factor
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
        addErrorView.superview?.bringSubviewToFront(addErrorView)
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
                    if (!self.addedWeathers.contains(currentWeatherResult)) {
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

extension CurrentWeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addedWeathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellName, for: indexPath)
        if let currentWeatherCell = cell as? CurrentWeatherCell {
            let currentWeather = addedWeathers[indexPath.row]
            currentWeatherCell.configure(with: currentWeather, at: indexPath.row)
        }
        return cell
    }
}

extension CurrentWeatherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.6, height: collectionView.frame.height * 0.8)
    }
}

extension CurrentWeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleAddingCity()
        textField.resignFirstResponder()
        return true
    }
}
