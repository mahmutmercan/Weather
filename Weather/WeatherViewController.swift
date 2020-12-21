//
//  WeatherViewController.swift
//  Weather
//
//  Created by Mahmut MERCAN on 1.12.2020.
//

import UIKit
import CoreLocation
import MapKit

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dailyWeatherTableView: UITableView!
    
    var gradient: CAGradientLayer?
    var models = [DailyWeatherEntry]()
    var models2 = [HourlyWeatherEntry]()
    var hourlyModels = [HourlyWeatherEntry]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var current: CurrentWeather?
    var weatherResponse: WeatherResponse?
    var timeZone: String!
    var myWeatherType: String?
    var currentCity: String?
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocation()
    }
    
    func setupTableView() {
        dailyWeatherTableView.backgroundColor = .clear
        dailyWeatherTableView.allowsSelection = false
        // Register 2 Cells
        dailyWeatherTableView.register(HourlyWeatherTableViewCell.nib(), forCellReuseIdentifier: HourlyWeatherTableViewCell.identifier)
        dailyWeatherTableView.register(DailyWeatherTableViewCell.nib(), forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        dailyWeatherTableView.register(HeaderWeatherTableViewCell.nib(), forCellReuseIdentifier: HeaderWeatherTableViewCell.identifier)
        
        dailyWeatherTableView.delegate = self
        dailyWeatherTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        setupGradient()
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            dailyWeatherTableView.refreshControl = refreshControl
        } else {
            dailyWeatherTableView.addSubview(refreshControl)
        }
        configureRefreshControl()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        dailyWeatherTableView.reloadData()
        
        DispatchQueue.main.async {
            self.dailyWeatherTableView.refreshControl?.endRefreshing()
         }
    }
    
    func configureRefreshControl () {
       // Add the refresh control to your UIScrollView object.
        dailyWeatherTableView.refreshControl = UIRefreshControl()
        dailyWeatherTableView.refreshControl?.addTarget(self, action:
                                          #selector(refreshWeatherData),
                                          for: .valueChanged)
        refreshControl.tintColor = UIColor.init(rgb: 0xffffff)
    }
 
    //Location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        setupGradient()
    }
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            self.currentCity = city
            
        }

        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.startUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        let key = "ddcc4ebb2a7c9930b90d9e59bda0ba7a"
        print("\(lat) | \(long)")

        let url = "https://api.darksky.net/forecast/\(key)/\(lat),\(long)?exclude=[flags,minutely]"
//        let url = "https://api.darksky.net/forecast/\(key)/37.00,-122?exclude=[flags,minutely]"


        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            // Validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            // Convert data to models/some object
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
                self.weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            guard let result = json else {
                return
            }

            let entries = result.daily.data
            let current = result.currently

            self.models.append(contentsOf: entries)
            self.current = current
            self.hourlyModels = result.hourly.data
            self.models2 = result.hourly.data
            self.timeZone = result.timezone
            self.myWeatherType = result.currently.icon.lowercased()
            // Update user interface
            DispatchQueue.main.async {
                self.dailyWeatherTableView.reloadData()
                self.setupGradient()
            }
        }).resume()
    }
    func calculateCelsius(fahrenheit: Double) -> Double {
        var celsius: Double
        var roundedCelsius: Double
        celsius = (fahrenheit - 32) / 1.8
        roundedCelsius = Double(round(10*celsius)/10)
        return roundedCelsius
    }

    func getDayForTime(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Monday
        return formatter.string(from: inputDate)
    }
    
    private func setupGradient(){
        gradient?.removeFromSuperlayer()
        
        var gradientStartColor = UIColor(red: 0/255.0, green: 242/255.0, blue: 96/255.0, alpha: 1.0).cgColor
        var gradientMidColor = UIColor(red: 0/255.0, green: 242/255.0, blue: 96/255.0, alpha: 1.0).cgColor
        var gradientEndColor = UIColor(red: 5/255.0, green: 117/255.0, blue: 230/255.0, alpha: 1.0).cgColor
        if myWeatherType == "clear-day" {
            gradientStartColor = UIColor.init(rgb: 0x2980b9).cgColor
            gradientMidColor = UIColor.init(rgb: 0x6dd5fa).cgColor
            gradientEndColor = UIColor.init(rgb: 0xffffff).cgColor

        } else if myWeatherType == "rain" {
            gradientStartColor = UIColor.init(rgb: 0x4b6bb7).cgColor
            gradientEndColor = UIColor.init(rgb: 0x182848).cgColor

        } else if myWeatherType == "clear-night" {
            gradientStartColor = UIColor.init(rgb: 0x8e9eab).cgColor
            gradientEndColor = UIColor.init(rgb: 0xc4cccf).cgColor
        } else if myWeatherType == "clear" {
            gradientStartColor = UIColor.init(rgb: 0x0082c8).cgColor
            gradientEndColor = UIColor.init(rgb: 0x0082c8).cgColor
            
        } else if myWeatherType == "snow" {
            gradientStartColor = UIColor.init(rgb: 0xc9d6ff).cgColor
            gradientEndColor = UIColor.init(rgb: 0xe2e2e2).cgColor
            
        } else if myWeatherType == "sleet" {
            gradientStartColor = UIColor.init(rgb: 0xc9d6ff).cgColor
            gradientEndColor = UIColor.init(rgb: 0xe2e2e2).cgColor
            
        } else if myWeatherType == "wind" {
            gradientStartColor = UIColor.init(rgb: 0x1c92d2).cgColor
            gradientEndColor = UIColor.init(rgb: 0xf2fcfe).cgColor
            
        } else if myWeatherType == "fog" {
            gradientStartColor = UIColor.init(rgb: 0xbdc3c7).cgColor
            gradientEndColor = UIColor.init(rgb: 0x2c3e50).cgColor
            
        } else if myWeatherType == "hail" {
            gradientStartColor = UIColor.init(rgb: 0xd5dce0).cgColor
            gradientEndColor = UIColor.init(rgb: 0x4a6075).cgColor
            
        } else if myWeatherType == "cloudy" {
            gradientStartColor = UIColor.init(rgb: 0xece9e6).cgColor
            gradientEndColor = UIColor.init(rgb: 0xffffff).cgColor
            
        } else if myWeatherType == "partly-cloudy-night" {
            gradientStartColor = UIColor.init(rgb: 0x83a4d4).cgColor
            gradientEndColor = UIColor.init(rgb: 0x5a9396).cgColor
            
        } else if myWeatherType == "partly-cloudy" || myWeatherType == "mostly-cloudy"{
            gradientStartColor = UIColor.init(rgb: 0x2c5383).cgColor
            gradientEndColor = UIColor.init(rgb: 0x5fafc9).cgColor
        } else {
            gradientStartColor = UIColor.init(rgb: 0x56ab2f).cgColor
            gradientEndColor = UIColor.init(rgb: 0x56ab2f).cgColor
        }
        gradient = CAGradientLayer()
        guard let gradient = gradient else { return }
        gradient.frame = view.layer.bounds
        gradient.colors = [gradientStartColor, gradientEndColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    //Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        }
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentWeather = self.current else {
            return UITableViewCell()
        }

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderWeatherTableViewCell.identifier, for: indexPath) as! HeaderWeatherTableViewCell
            print(self.currentCity ?? "")
            cell.backgroundColor = .clear
            cell.configure(with: self.current!)
            let temparatureResult = calculateCelsius(fahrenheit: currentWeather.temperature)
            let locationLabelList = weatherResponse?.timezone.components(separatedBy: "/")
            let currentlocationLabel = locationLabelList?[1]
            let modifiedLabel = currentlocationLabel?.replace(target: "_", withString: " ")
            print(modifiedLabel ?? "")
            cell.locationLabel.text = String(modifiedLabel ?? "Your Location")
            cell.tempLabel.text = "\(String(temparatureResult))°"
            cell.summaryLabel.text = "\(String(self.current!.summary))"
            
            if self.currentCity != nil{
                cell.locationLabel.text = String(self.currentCity ?? "Your Location")
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherTableViewCell.identifier, for: indexPath) as! HourlyWeatherTableViewCell
            cell.backgroundColor = .clear
            cell.configure(with: hourlyModels)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier, for: indexPath) as! DailyWeatherTableViewCell
        cell.backgroundColor = .clear
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 256
        } else if indexPath.section == 1 {
            return 96
        } else {
            return 60
        }
    }
}

struct WeatherResponse: Codable {
    let latitude: Float
    let longitude: Float
    let timezone: String
    let currently: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
    let offset: Float
}

struct CurrentWeather: Codable {
    let time: Int
    let summary: String
    let icon: String
    let nearestStormDistance: Int
    let nearestStormBearing: Int
    let precipIntensity: Int
    let precipProbability: Int
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}

struct DailyWeather: Codable {
    let summary: String
    let icon: String
    let data: [DailyWeatherEntry]
}

struct DailyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let sunriseTime: Int
    let sunsetTime: Int
    let moonPhase: Double
    let precipIntensity: Float
    let precipIntensityMax: Float
    let precipIntensityMaxTime: Int
    let precipProbability: Double
    let precipType: String?
    let temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windGustTime: Int
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let uvIndexTime: Int
    let visibility: Double
    let ozone: Double
    let temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
}

struct HourlyWeather: Codable {
    let summary: String
    let icon: String
    let data: [HourlyWeatherEntry]
}

struct HourlyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let precipIntensity: Float
    let precipProbability: Double
    let precipType: String?
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}
