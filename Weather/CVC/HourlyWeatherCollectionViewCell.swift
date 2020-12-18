//
//  HourlyWeatherCollectionViewCell.swift
//  Weather
//
//  Created by Mahmut MERCAN on 3.12.2020.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourlyWeatherCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    
    func configure(with model: HourlyWeatherEntry) {
        self.tempLabel.text = "\(model.temperature)"

        self.iconImageView.contentMode = .scaleAspectFit
        let icon = model.icon.lowercased()
        

        if icon.contains("clear-day") {
            self.iconImageView.image = UIImage(named: "Sun")
            
        } else if icon.contains("clear-night") {
            self.iconImageView.image = UIImage(named: "Moon")
            
        } else if icon.contains("rain"){
            self.iconImageView.image = UIImage(named: "Cloud_angled_rain")
            
        } else if icon.contains("clear"){
            self.iconImageView.image = UIImage(named: "Sun")
            
        } else if icon.contains("snow"){
            self.iconImageView.image = UIImage(named: "Big snow")
            
        } else if icon.contains("sleet"){
            self.iconImageView.image = UIImage(named: "Cloud_little_snow")
            
        } else if icon.contains("wind"){
            self.iconImageView.image = UIImage(named: "Fast_winds")
            
        }
//        else if icon.contains("fog"){
//            self.iconImageView.image = UIImage(named: "")
//
//        }
        else if icon.contains("hail"){
            self.iconImageView.image = UIImage(named: "Cloud_hailstone")
            
        } else if icon.contains("cloudy"){
            self.iconImageView.image = UIImage(named: "Cloud")
            
        } else if icon.contains("partly-cloudy-day"){
            self.iconImageView.image = UIImage(named: "Cloud_sunset")
            
        }else {
            self.iconImageView.image = UIImage(named: "Big_rain_drops")
            
        }

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
