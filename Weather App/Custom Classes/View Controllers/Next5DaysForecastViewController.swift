//
//  Next5DaysForecastViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class Next5DaysForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private let forecastService = ForecastService()
    
    private var gradient: Gradient!
    
    lazy var futureWeathers = [FutureWeather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient = Gradient(gradientName: Gradient.GradientNames.background)
        gradient.addBackgroundColor(to: view)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UINib(nibName: "ForecastTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ForecastTableViewCell"
        )
        
        //TODO: Temporary
        forecastService.getForecast(for: "Tbilisi")
        do {
            futureWeathers = try (DatabaseManager.getLocation(for: "Tbilisi", in: DatabaseManager.shared.persistentContainer.viewContext)?.futureWeathers)!
            tableView.reloadData()
        } catch {}
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.updateFrameBounds(to: view.frame)
    }
}

extension Next5DaysForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return futureWeathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath)
        if let forecastTableViewCell = cell as? ForecastTableViewCell {
            let futureWeather = futureWeathers[indexPath.row]
            forecastTableViewCell.configure(with: futureWeather)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}

extension Next5DaysForecastViewController {
    struct Constants {
        static let rowHeight: CGFloat = 66
    }
}
