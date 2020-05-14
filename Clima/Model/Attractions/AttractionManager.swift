//
//  HotelManager.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

extension NSDictionary{
    
    var swiftDictionary: Dictionary<String,Any>{
        var swiftDict = Dictionary<String,Any>();
        
        for key : Any in self.allKeys{
            let stringKey = key as! String;
            if let keyValue = self.value(forKey: stringKey){
                if type(of: keyValue) == NSDictionary.self{
                    var NSDkeyValue = keyValue as! NSDictionary
                    swiftDict[stringKey] = NSDkeyValue.swiftDictionary
                }
                else{
                     swiftDict[stringKey] = keyValue
                }
               
            }
        }
        
        return swiftDict
    }
}

class Attractions{
    
    var mainURL = "https://dev.safra-connect.safra.me";
    var apiToken = "Ds7hkgCs0x6l3xve3VuInXk8Et0tbgsF";
    var delegate: UpdateAttractions?;
    
    
    static func parseData(_ dict : Any) -> Any{
        var finalData = Array<AttractionModel>();
        if let safeDict = dict as? Array<Any>{
            for dataline in safeDict{
                if let Dict = dataline as? [String:Any]{
//                    print(Dict);
                    var newAttraction = AttractionModel();
                    newAttraction.name = Dict["name"] as? String;
                    newAttraction.address = Dict["address"] as? String;
                    newAttraction.num_reviews = Dict["num_reviews"] as? String;
                    newAttraction.location_string = Dict["location_string"] as? String;
                    newAttraction.ranking = Dict["ranking"] as? String;
                    newAttraction.distance = Dict["distance"] as? String;
                    newAttraction.rating = Dict["rating"] as? String;
                    newAttraction.phone = Dict["phone"] as? String;
                    newAttraction.parseOffer((Dict["offer_group"] as? NSDictionary) ?? nil);
                    newAttraction.parseBooking((Dict["booking"] as? NSDictionary) ?? nil);
                    finalData.append(newAttraction);
                }
            }
        }
        
        return finalData
    }
    
    
    func findAttractions(_ lat:Double, _ lon:Double){
        let APICall = TripAdvisorAPI( [
                   "x-rapidapi-host": "tripadvisor1.p.rapidapi.com",
                   "x-rapidapi-key": "7746cb9f54msh2d203691cf02f42p161bc2jsn4079f978fca9",
                   "content-type" : "application/json"
        ], "https://tripadvisor1.p.rapidapi.com/attractions/list-by-latlng?lunit=km&currency=USD&limit=30&distance=5&lang=en_US&longitude=\(lon)&latitude=\(lat)");
        
        APICall.getData(){(data,response,error) in
            guard let safeData = data else { return }
            do{
                let dict = try JSONSerialization.jsonObject(with: safeData, options: .mutableContainers) as? [String:Any];
                let finalData = Attractions.parseData(dict?["data"]);
                self.delegate?.performAttractionUpdate(finalData)
            }catch{
                print("Error")
            }
        }
    }
    
   
}
