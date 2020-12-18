//
//  DailyWeatherTableViewCell.swift
//  Weather
//
//  Created by Mahmut MERCAN on 1.12.2020.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    static let identifier = "DailyWeatherTableViewCell"
    static func nib() -> UINib {
    return UINib(nibName: "DailyWeatherTableViewCell", bundle: nil)
    }
    func configure(with model: DailyWeatherEntry) {
        
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        self.lowTempLabel.text = "\(Int(model.temperatureLow))°"
        self.highTempLabel.text = "\(Int(model.temperatureHigh))°"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.time)))
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
        } else if icon.contains("fog"){
            self.iconImageView.image = UIImage(named: "slow_winds")
        } else if icon.contains("hail"){
            self.iconImageView.image = UIImage(named: "Cloud_hailstone")
        } else if icon.contains("cloudy"){
            self.iconImageView.image = UIImage(named: "Cloud")
        } else if icon.contains("partly-cloudy-day"){
            self.iconImageView.image = UIImage(named: "sun_cloud")
        } else {
            self.iconImageView.image = UIImage(named: "Big_rain_drops")
        }
    }
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
    }
}
