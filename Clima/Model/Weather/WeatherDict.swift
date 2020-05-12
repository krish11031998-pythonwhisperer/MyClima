//
//  WeatherDict.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherDict: Decodable{
    var name: String?;
    var coord:coordinates;
    var main: Main?;
    var weather: [Weather];
}


struct coordinates : Codable{
    var lon:Double;
    var lat:Double;
}

struct Main:Decodable{
    var temp:Double;
    var feels_like:Double;
    var temp_min : Double;
    var temp_max: Double;
    var pressure: Int;
    var humidity:Int;
}


struct Weather : Decodable{
    var id:Int?;
    var main:String?;
}
