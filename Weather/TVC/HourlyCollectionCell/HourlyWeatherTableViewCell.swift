//
//  HourlyWeatherTableViewCell.swift
//  Weather
//
//  Created by Mahmut MERCAN on 1.12.2020.
//

import UIKit

class HourlyWeatherTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var hourlyCollectionView: UICollectionView!
    var models = [HourlyWeatherEntry]()

    override func awakeFromNib() {
        super.awakeFromNib()
        hourlyCollectionView.register(HourlyWeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.identifier)
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    static let identifier = "HourlyWeatherTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HourlyWeatherTableViewCell",
                     bundle: nil)
    }
    
    func configure(with models: [HourlyWeatherEntry]) {
        self.models = models
        hourlyCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as! HourlyWeatherCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
}
