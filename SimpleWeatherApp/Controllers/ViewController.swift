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
        
        fetchWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: Tableview methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return hourDataArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 44
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as UITableViewCell!
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Current Weather"
        }else{
            
            
            
            cell.textLabel?.text = "Hourly \(indexPath.row)"
        }
        
        
        return cell
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

