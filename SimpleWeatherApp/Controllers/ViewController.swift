//
//  ViewController.swift
//  SimpleWeatherApp
//
//  Created by Malcolmn Roberts on 2018/04/24.
//  Copyright © 2018 Malcolmn Roberts. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentWeatherDic: Dictionary<String, AnyObject> = [:]
    var hourWeatherDic: Dictionary<String, AnyObject> = [:]
    var hourDataArray = NSArray()
    
    @IBOutlet var table_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table_view.delegate = self
        table_view.dataSource = self
        
        table_view.register(WeatherCell.self, forCellReuseIdentifier: "WeatherCell")
        table_view.register(WeatherHourCell.self, forCellReuseIdentifier: "WeatherHourCell")
        
        let refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                #selector(ViewController.handleRefresh(_:)),
                                     for: UIControlEvents.valueChanged)
            refreshControl.tintColor = UIColor.red
            
            return refreshControl
        }()
        table_view.refreshControl = refreshControl
        
        fetchWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        fetchWeather()
        refreshControl.endRefreshing()
    }
    
// MARK: Tableview methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if self.currentWeatherDic["time"] != nil {
                return 1
            }else{
                return 0
            }
        case 1:
            return hourDataArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 178
        case 1:
            return 46
        default:
            return 46
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell:WeatherCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell!
            
            let time = NSDate(timeIntervalSince1970: TimeInterval(truncating: self.currentWeatherDic["time"] as! NSNumber))
            let dateFormatter = DateFormatter()
            
            TimeZone.ReferenceType.default = TimeZone(abbreviation: "UTC")!
            dateFormatter.timeZone = TimeZone.ReferenceType.default
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            let str = dateFormatter.string(from: time as Date)
            
            let temperature = UtilitiesHelper.sharedInstance.convertToCelius(Temperature: self.currentWeatherDic["temperature"] as! Float)
            
            cell.setCellValues(Title: String.init(format: "Today %@", str),
                               Summary: self.currentWeatherDic["summary"] as! String,
                               Temperature: String.init(format: "Today %.0f°C", temperature),
                               WindSpeed: String.init(format: "Today %.2f km/h", self.currentWeatherDic["windSpeed"] as! Float))
            
            return cell
            
        }else{
            let cell:WeatherHourCell = tableView.dequeueReusableCell(withIdentifier: "WeatherHourCell") as! WeatherHourCell!
            
            let tempDic = self.hourDataArray[indexPath.row] as! Dictionary<String, AnyObject>

            let time = NSDate(timeIntervalSince1970: TimeInterval(truncating: tempDic["time"] as! NSNumber))
            let dateFormatter = DateFormatter()
            
            TimeZone.ReferenceType.default = TimeZone(abbreviation: "UTC")!
            dateFormatter.timeZone = TimeZone.ReferenceType.default
            dateFormatter.dateFormat = "hh:mm"
            let str = dateFormatter.string(from: time as Date)
            
            let temperature = UtilitiesHelper.sharedInstance.convertToCelius(Temperature: tempDic["temperature"] as! Float)
            
            cell.setCellValues(Time: str,
                               Temperature: String.init(format: "Today %.0f°C", temperature),
                               WindSpeed: String.init(format: "Today %.2f km/h", self.currentWeatherDic["windSpeed"] as! Float))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    
// MARK: API methods
    
    class Connectivity {
        class var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    func fetchWeather() {
        
        if Connectivity.isConnectedToInternet {
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "Syncing"
           
            Alamofire.request("http://ec-weather-proxy.appspot.com/forecast/29e4a4ce0ec0068b03fe203fa81d457f/-33.9249,18.4241?delay=5&chaos=0.2", method:.get, encoding: JSONEncoding.init(options: [])).responseJSON { response in

                if let status = response.response?.statusCode {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    switch(status){
                    case 200:
                        print("API success")
                        let JSON = response.result.value as! NSDictionary
                        
                        self.currentWeatherDic = (JSON.object(forKey: "currently") as? Dictionary<String,AnyObject>)!
                        self.hourWeatherDic = (JSON.object(forKey: "hourly") as? Dictionary<String,AnyObject>)!
                        self.hourDataArray = self.hourWeatherDic["data"] as! NSArray
                        
                        self.table_view.reloadData()
                        
                    default:
                        print("error with response status: \(status)")
                        
                        self.errorPopup(title: "Error", body: "Could not sync weather information, please try again")
                    }
                }
            }
        }else{
            print("NO! internet is unavailable.")
            errorPopup(title: "No internet", body: "Please check your internet connection and try again")
        }
    }
    
    func errorPopup(title:String,body:String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}

