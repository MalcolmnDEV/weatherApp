//
//  WeatherCell.swift
//  SimpleWeatherApp
//
//  Created by Malcolmn Roberts on 2018/04/24.
//  Copyright © 2018 Malcolmn Roberts. All rights reserved.
//

import Foundation
import UIKit

class WeatherCell: UITableViewCell {
    var lblTitle: UILabel!
    var lblSummary: UILabel!
    var weatherImage: UIImageView!
    var lblTemp: UILabel!
    var lblWindSpeed: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.blue
        
        lblTitle = UILabel()
        lblSummary = UILabel()
        weatherImage = UIImageView()
        lblTemp = UILabel()
        lblWindSpeed = UILabel()
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = false;
        lblSummary.translatesAutoresizingMaskIntoConstraints = false;
        weatherImage.translatesAutoresizingMaskIntoConstraints = false;
        lblTemp.translatesAutoresizingMaskIntoConstraints = false;
        lblWindSpeed.translatesAutoresizingMaskIntoConstraints = false;
        
        lblTitle.textColor = .white
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.textAlignment = .center
        
        lblSummary.textColor = .white
        lblSummary.font = UIFont.systemFont(ofSize: 18)
        lblSummary.textAlignment = .center
        
        weatherImage.contentMode = .scaleAspectFit
        
        lblTemp.textColor = .white
        lblTemp.font = UIFont.systemFont(ofSize: 14)
        lblTemp.textAlignment = .center
        
        lblWindSpeed.textColor = .white
        lblWindSpeed.font = UIFont.systemFont(ofSize: 14)
        lblWindSpeed.textAlignment = .center
        
        self.addSubview(lblTitle)
        self.addSubview(lblSummary)
        self.addSubview(weatherImage)
        self.addSubview(lblTemp)
        self.addSubview(lblWindSpeed)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraints()
    }
    
    func addConstraints(){
        
        let views: [String: Any] = [
            "lblTitle": lblTitle,
            "lblSummary": lblSummary,
            "weatherImage":weatherImage,
            "lblTemp": lblTemp,
            "lblWindSpeed" : lblWindSpeed]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-8-[lblTitle(32)]-16-[lblSummary(20)]-16-[weatherImage(44)]-16-[lblTemp(18)]-8-|",
            metrics: nil,
            views: views)
        allConstraints += verticalConstraints
        
        let speedVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[weatherImage]-16-[lblWindSpeed(18)]-8-|",
            metrics: nil,
            views: views)
        allConstraints += speedVerticalConstraints
        
        let titleHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[lblTitle]-15-|",
            metrics: nil,
            views: views)
        allConstraints += titleHorizontalConstraint
        
        let summaryHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[lblSummary]-15-|",
            metrics: nil,
            views: views)
        allConstraints += summaryHorizontalConstraint
        
        let imageHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[weatherImage]-15-|",
            metrics: nil,
            views: views)
        allConstraints += imageHorizontalConstraint
        
        let tempSpeedHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[lblTemp(==lblWindSpeed)]-15-[lblWindSpeed(==lblTemp)]-15-|",
            metrics: nil,
            views: views)
        allConstraints += tempSpeedHorizontalConstraint
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    func setCellValues(Title:String, Summary:String, Temperature:String, WindSpeed:String){
        lblTitle.text = Title
        lblSummary.text = Summary
        lblTemp.text = Temperature
        lblWindSpeed.text = WindSpeed
        
        if Summary.lowercased().range(of:"partly") != nil {
            weatherImage.image = UIImage(named:"ic_partly_cloudy")
        }else if Summary.lowercased().range(of:"rain") != nil {
            weatherImage.image = UIImage(named:"ic_rainy")
        }else if Summary.lowercased().range(of:"cloud") != nil {
            weatherImage.image = UIImage(named:"ic_cloudy")
        }else{
            weatherImage.image = UIImage(named:"ic_sunny")
        }
        
    }
}
