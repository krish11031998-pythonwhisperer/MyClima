//
//  CityManager.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


class City{
    
    var mainURL = "https://tripadvisor1.p.rapidapi.com/locations/search?location_id=1&limit=30&sort=relevance&offset=0&lang=en_US&currency=USD&units=km";
    var delegate: UpdateCity?;
    
    func getCityDetails(city:String="Athens"){
        
        let APICall = TripAdvisorAPI([
            "x-rapidapi-host": "tripadvisor1.p.rapidapi.com",
            "x-rapidapi-key": "7746cb9f54msh2d203691cf02f42p161bc2jsn4079f978fca9",
            "content-type" : "application/json"
        ], "\(self.mainURL)&query=\(city)");
        
        APICall.getData(){(data,response,error) in
            guard let safeData = data else { return }
            do{
                let json = try JSONSerialization.jsonObject(with: safeData, options: .mutableContainers) as? [String:Any];
                let parsingData = json?["data"]
                let finalData = self.parseData(parsingData);
                self.delegate?.performCityUpdate(finalData);
            }catch{
                print("There was an error");
            }
        }
    }
    
    func parseData(_ data:Any) -> CityModel{
        var newCityModel = CityModel();
        print(data);
        if let safeData = data as? Array<Any>{
            if let firstData = safeData[0] as? [String:Any]{
                let result =  firstData["result_object"]
                if let safeResult = result as? [String:Any]{
                    newCityModel.name = safeResult["name"] as? String;
                    newCityModel.latitude = Double((safeResult["latitude"] as? String)!);
                    newCityModel.longitude = Double((safeResult["longitude"] as? String)!);
                    newCityModel.location_id = safeResult["location_id"] as? String;
                    newCityModel.geo_description = safeResult["geo_description"] as? String;
                    if let safePhotos = safeResult["photo"] as? [String:Any]{
                        if let safeImages = safePhotos["images"] as? [String:Any]{
                            if let safeSmallImage = safeImages["original"] as? [String:Any]{
                                newCityModel.photo = safeSmallImage["url"] as? String;
                            }
                        }
                    }
                }
            }
            
        }
        print(newCityModel);
        return newCityModel;
    }
    
}
