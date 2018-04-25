//
//  WeatherHourCell.swift
//  SimpleWeatherApp
//
//  Created by Malcolmn Roberts on 2018/04/25.
//  Copyright © 2018 Malcolmn Roberts. All rights reserved.
//

import Foundation
import UIKit

class WeatherHourCell: UITableViewCell {
    var lblTime: UILabel!
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
        self.backgroundColor = UIColor.white
        
        lblTime = UILabel()
        lblTemp = UILabel()
        lblWindSpeed = UILabel()
        
        lblTime.translatesAutoresizingMaskIntoConstraints = false;
        lblTemp.translatesAutoresizingMaskIntoConstraints = false;
        lblWindSpeed.translatesAutoresizingMaskIntoConstraints = false;
        
        lblTime.textColor = .blue
        lblTime.font = UIFont.boldSystemFont(ofSize: 18)
        lblTime.textAlignment = .center
        
        lblTemp.textColor = .blue
        lblTemp.font = UIFont.systemFont(ofSize: 14)
        lblTemp.textAlignment = .center
        
        lblWindSpeed.textColor = .blue
        lblWindSpeed.font = UIFont.systemFont(ofSize: 14)
        lblWindSpeed.textAlignment = .center
        
        self.addSubview(lblTime)
        self.addSubview(lblTemp)
        self.addSubview(lblWindSpeed)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addConstraints()
    }
    
    func addConstraints(){
        
        let views: [String: Any] = [
            "lblTime": lblTime,
            "lblTemp": lblTemp,
            "lblWindSpeed" : lblWindSpeed]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-4-[lblTime(18)]-4-[lblTemp(16)]-4-|",
            metrics: nil,
            views: views)
        allConstraints += verticalConstraints
        
        let speedVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[lblTime]-4-[lblWindSpeed(16)]-4-|",
            metrics: nil,
            views: views)
        allConstraints += speedVerticalConstraints
        
        let titleHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[lblTime]-15-|",
            metrics: nil,
            views: views)
        allConstraints += titleHorizontalConstraint
        
        let tempSpeedHorizontalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[lblTemp(==lblWindSpeed)]-15-[lblWindSpeed(==lblTemp)]-15-|",
            metrics: nil,
            views: views)
        allConstraints += tempSpeedHorizontalConstraint
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    func setCellValues(Time:String, Temperature:String, WindSpeed:String){
        lblTime.text = Time
        lblTemp.text = Temperature
        lblWindSpeed.text = WindSpeed
        
    }
}
