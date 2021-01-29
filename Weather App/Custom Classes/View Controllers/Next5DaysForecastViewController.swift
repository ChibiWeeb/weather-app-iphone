//
//  Next5DaysForecastViewController.swift
//  Weather App
//
//  Created by Nika Nikolishvili on 27.01.21.
//

import UIKit

class Next5DaysForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var gradient: Gradient!
    
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
        
        //TEMPORARY
        //TODO: Seperate service class L15-1:42:30
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=tbilisi&units=metric&appid=cf270b8b540ec2bbdc4c6aa1093b0653")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(ForecastResponse.self, from: data)
                    print(result)
                } catch {
                    print(error)
                }
            }
        })
        task.resume()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.updateFrameBounds(to: view.frame)
    }
}

extension Next5DaysForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath)
        
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
