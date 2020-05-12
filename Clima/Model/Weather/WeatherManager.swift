//
//  WeatherManager.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class WeatherManager{
    
    var weather_url = "https://api.openweathermap.org/data/2.5/weather?appid=7b509e5e1d1e7ff010a0476dae3589ad&units=metric";
    
    var delegate: Update?;
    func destinationWeather(destination:String){
        let destinationURL = "\(self.weather_url)&q=\(destination)";
//        print(destinationURL);
        self.fetchWeatherData(urlstring:destinationURL);
    }
    
    func destinationWeather(lattitude lat: Int, longitude lon:Int){
        let destinationURL = "\(self.weather_url)&lat=\(lat)&lon=\(lon)";
        self.fetchWeatherData(urlstring: destinationURL);
    }
    
    func fetchWeatherData(urlstring:String){
        
            // Create an URL
        if let url = URL(string: urlstring){
        
            // Create an Session
            let session = URLSession(configuration: .default);
        
            //Create a task
            let task = session.dataTask(with: url, completionHandler: {(data,response,error) in
    
                if error != nil{
                    print(error!);
                    self.delegate?.didFailDuringRequest(error!);
                    return;
                }
                
                if let safeData = data{
                    if let decodedData = self.parseJSON(data: safeData){
                        self.delegate?.performUIUpdate(decodedData);
                    }
                }else if let safeResponse = response{
                    self.delegate?.didFailDuringRequest(safeResponse)
                }
            
            })
            //strt task
            task.resume();
        }
        
    }
    
    func parseJSON(data:Data) -> WeatherModel?{
        let decoder = JSONDecoder();
        do{
            let decoderData = try decoder.decode(WeatherDict.self, from: data);
//            print(decoderData.name ?? "");
//            print(decoderData.main?.temp ?? 0.0);
            var weatherResults = WeatherModel(city: decoderData.name ?? "", temp: decoderData.main?.temp ?? 0.0, id: decoderData.weather[0].id ?? 0,extraInfo: decoderData,lon: Double(decoderData.coord.lon ?? 0), lat: Double(decoderData.coord.lat ?? 0))
            return weatherResults
        }catch{
            print(error);
            self.delegate?.didFailDuringDecoding(error);
        }
        return nil
    }
    
}
