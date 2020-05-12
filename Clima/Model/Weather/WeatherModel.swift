//
//  weatherModel.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    
    var city:String;
    var temp:Double;
    var id:Int;
    var extraInfo:Any;
    var lon : Double;
    var lat : Double;
    var temperature:String{
        return String(format: "%0.1f",Float(self.temp));
    }
    
    var weatherCondition:String{
        switch(self.id){
            case 200..<300:
                return "Thunderstorm";
            case 300..<400:
                return "Drizzle"
            case 500..<600:
                return "Rain"
            case 600..<700:
                return "Snow"
            case 700..<800:
                return "Atmosphere"
            case 801..<900:
                return "Clouds"
            case 800:
                return "Clear"
            default:
                return ""
        }
    }
    
}
