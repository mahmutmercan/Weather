//
//  HeaderWeatherTableViewCell.swift
//  Weather
//
//  Created by Mahmut MERCAN on 4.12.2020.
//

import UIKit

class HeaderWeatherTableViewCell: UITableViewCell {

    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    var models2 = [HourlyWeatherEntry]()
    var current: CurrentWeather?
    let mf = MeasurementFormatter()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    static let identifier = "HeaderWeatherTableViewCell"
    static func nib() -> UINib {
    return UINib(nibName: "HeaderWeatherTableViewCell",
                 bundle: nil)
    }
    func configure(with model: CurrentWeather) {
        self.weatherImageView.contentMode = .scaleAspectFit
        
        let icon = model.icon.lowercased()
        
        if icon.contains("clear-day") {
            self.weatherImageView.image = UIImage(named: "Sun")
            
        } else if icon.contains("clear-night") {
            self.weatherImageView.image = UIImage(named: "Moon")
            
        } else if icon.contains("rain"){
            self.weatherImageView.image = UIImage(named: "Cloud_angled_rain")
            
        } else if icon.contains("clear"){
            self.weatherImageView.image = UIImage(named: "Sun")
            
        } else if icon.contains("snow"){
            self.weatherImageView.image = UIImage(named: "Big snow")
            
        } else if icon.contains("sleet"){
            self.weatherImageView.image = UIImage(named: "Cloud_little_snow")
            
        } else if icon.contains("wind"){
            self.weatherImageView.image = UIImage(named: "Fast_winds")
            
        }
        else if icon.contains("fog"){
            self.weatherImageView.image = UIImage(named: "fog")
            
        }
        else if icon.contains("hail"){
            self.weatherImageView.image = UIImage(named: "Cloud_hailstone")
            
        } else if icon.contains("cloudy"){
            self.weatherImageView.image = UIImage(named: "Cloud")
            
        } else if icon.contains("partly-cloudy-day"){
            self.weatherImageView.image = UIImage(named: "Cloud_sunset")
            
        }else {
            self.weatherImageView.image = UIImage(named: "Big_rain_drops")
            
        }
    }

    

}


