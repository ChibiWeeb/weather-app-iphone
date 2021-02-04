//
//  ForecastViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    private let gradient = Gradient(gradientName: .background)
    private let forecastService = Service<ForecastResponse>()
    private lazy var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.addBackgroundColor(to: view)
        setupTableView()
        loadForecasts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.updateFrameBounds(to: view.frame)
    }
    
    @IBAction func refresh() {
        loadForecasts()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: Constants.cellName, bundle: nil),
            forCellReuseIdentifier: Constants.cellName
        )
    }
    
    private func loadForecasts() {
        tableView.isHidden = true
        loader.startAnimating()
        forecastService.getServiceResult(for: "Tbilisi") { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                switch result {
                case .success(let forecastResult):
                    self.forecasts = forecastResult.list
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName, for: indexPath)
        if let forecastTableViewCell = cell as? ForecastTableViewCell {
            let forecast = forecasts[indexPath.row]
            forecastTableViewCell.configure(with: forecast)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}

extension ForecastViewController {
    struct Constants {
        static let cellName = "ForecastTableViewCell"
        static let rowHeight: CGFloat = 66
    }
}
