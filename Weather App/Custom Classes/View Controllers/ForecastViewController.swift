//
//  ForecastViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class ForecastSection {
    var header: String
    var forecasts = [Forecast]()
    
    init(header: String, forecasts: [Forecast]) {
        self.header = header
        self.forecasts = forecasts
    }
}

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    
    private let gradient = Gradient(gradientName: .background)
    private let forecastService = Service<ForecastResponse>()
    private var forecastTableData = [ForecastSection]()
    private var loadedCity = ActiveCity.shared.name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.addBackgroundColor(to: view)
        errorView.reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        setupTableView()
        loadForecasts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (loadedCity != ActiveCity.shared.name) {
            loadForecasts()
        }
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
        tableView.register(
            UINib(nibName: Constants.headerName, bundle: nil),
            forHeaderFooterViewReuseIdentifier: Constants.headerName
        )
    }
    
    private func loadForecasts() {
        let activeCity = ActiveCity.shared.name ?? ""
        tableView.isHidden = true
        errorView.isHidden = true
        loader.startAnimating()
        
        forecastService.getServiceResult(for: activeCity, at: nil) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                switch result {
                case .success(let forecastResult):
                    self.forecastTableData = self.makeForecastTableData(from: forecastResult.list)
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.loadedCity = activeCity
                case .failure(_):
                    self.errorView.isHidden = false
                }
            }
        }
    }
    
    private func makeForecastTableData(from forecastList: [Forecast]) -> [ForecastSection] {
        var forecastTableData = [ForecastSection]()
        var sectionMadeFor = [
            "Monday": false,
            "Tuesday": false,
            "Wednesday": false,
            "Thursday": false,
            "Friday": false,
            "Saturday": false,
            "Sunday": false
        ]
        
        for forecast in forecastList {
            let header = FormattedDay(
                timeInterval: TimeInterval(forecast.dt),
                dateFormat: .day
            ).getFormattedDate()
            
            if (sectionMadeFor[header]!) {
                for forecastSection in forecastTableData {
                    if (forecastSection.header == header) {
                        forecastSection.forecasts.append(forecast)
                        break
                    }
                }
            } else {
                let forecastSection = ForecastSection(header: header, forecasts: [forecast])
                forecastTableData.append(forecastSection)
                sectionMadeFor[header] = true
            }
        }
        return forecastTableData
    }
}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastTableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastTableData[section].forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName, for: indexPath)
        if let forecastTableViewCell = cell as? ForecastTableViewCell {
            let forecast = forecastTableData[indexPath.section].forecasts[indexPath.row]
            forecastTableViewCell.configure(with: forecast)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerName)
        if let forecastTableViewHeader = header as? ForecastTableViewHeader {
            forecastTableViewHeader.setDayLabelText(as: forecastTableData[section].header)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat.leastNonzeroMagnitude
    }
}

extension ForecastViewController {
    struct Constants {
        static let cellName = "ForecastTableViewCell"
        static let rowHeight: CGFloat = 66
        static let headerName = "ForecastTableViewHeader"
        static let headerHeight: CGFloat = 44
    }
}
