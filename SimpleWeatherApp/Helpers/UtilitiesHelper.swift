//
//  UtilitiesHelper.swift
//  SimpleWeatherApp
//
//  Created by Malcolmn Roberts on 2018/04/25.
//  Copyright © 2018 Malcolmn Roberts. All rights reserved.
//

import Foundation

class UtilitiesHelper {
    static let sharedInstance = UtilitiesHelper()
    private init() {
        
    }
    
    func convertToCelius(Temperature: Float) -> Float{
        return (Temperature - 32.0)*0.5556
    }
}
