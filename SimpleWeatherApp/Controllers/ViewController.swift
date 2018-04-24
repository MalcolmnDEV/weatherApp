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
    var hourDataArray: [Dictionary<String, AnyObject>] = []
    
    @IBOutlet var table_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table_view.delegate = self
        table_view.dataSource = self
        
        table_view.register(WeatherCell.self, forCellReuseIdentifier: "WeatherCell")
        
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
            return 118
        case 1:
            return 44
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell:WeatherCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell!
            
            cell.setCellValues(Title: String.init(format: "Today %ld", self.currentWeatherDic["time"] as! NSNumber),
                               Summary: self.currentWeatherDic["summary"] as! String,
                               Temperature: String.init(format: "Today %ld", self.currentWeatherDic["temperature"] as! NSNumber),
                               WindSpeed: String.init(format: "Today %ld", self.currentWeatherDic["windSpeed"] as! NSNumber))
            
            return cell
            
        }else{
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherHourCell") as UITableViewCell!
            cell.textLabel?.text = "Hourly \(indexPath.row)"
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
//                print("Request: \(String(describing: response.request))")   // original url request
//                print("Response: \(String(describing: response.response))") // http url response
//                print("Result: \(response.result)")                         // response serialization result

                if let status = response.response?.statusCode {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    switch(status){
                    case 200:
                        print("API success")
                        let JSON = response.result.value as! NSDictionary
                        
                        self.currentWeatherDic = (JSON.object(forKey: "currently") as? Dictionary<String,AnyObject>)!
                        self.hourWeatherDic = (JSON.object(forKey: "hourly") as? Dictionary<String,AnyObject>)!
//                        self.hourDataArray = self.hourWeatherDic["data"]
                        
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

