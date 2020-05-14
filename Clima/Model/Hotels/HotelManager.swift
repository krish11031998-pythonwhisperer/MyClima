//
//  HotelManager.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/15/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


class HotelManager{
    
    var delegate:UpdateHotel?;
    var HotelData:Array<HotelModel>?;
    
    func fetchHotels(_ locaiton_id:String, _ adults:Int = 1, _ rooms:Int = 1){
        var APICall = TripAdvisorAPI([
            "x-rapidapi-host": "tripadvisor1.p.rapidapi.com",
            "x-rapidapi-key": "7746cb9f54msh2d203691cf02f42p161bc2jsn4079f978fca9"
        ], "https://tripadvisor1.p.rapidapi.com/hotels/list?offset=0&currency=USD&limit=30&order=asc&lang=en_US&sort=recommended&nights=2&location_id=\(locaiton_id)&adults=\(adults)&rooms=\(rooms)");
        
        APICall.getData(){(data,response,error) in
            
            guard let safeData = data else { return }
            do{
                let dict = try JSONSerialization.jsonObject(with: safeData, options: .mutableContainers) as? [String:Any];
                self.parseData(dict?["data"]);
                self.delegate?.performHotelUpdate(self.HotelData)
                return;
            }catch{
                print("There was an error");
            }
        }
        
    }
    
    func parseData(_ data:Any){
        guard let safeData = data as? Array<Any> else { return }
        var HotelData = safeData.map({ (hotel) -> HotelModel? in
            guard let safeHotel = hotel as? [String:Any] else { return nil }
            var newHotel = HotelModel();
            newHotel.name = safeHotel["name"] as? String;
            newHotel.location_id = safeHotel["location_id"] as? String;
            newHotel.location_string = safeHotel["location_string"] as? String;
            newHotel.lat = safeHotel["latitude"] as? String;
            newHotel.lon = safeHotel["longitude"] as? String;
            newHotel.hotel_class = safeHotel["hotel_class"] as? String;
            newHotel.price = safeHotel["price"] as? String;
            newHotel.price_level = safeHotel["price_level"] as? String;
            newHotel.rating = safeHotel["rating"] as? String;
            if let safePhotos = safeHotel["photo"] as? [String:Any]{
                if let safeImages = safePhotos["images"] as? [String:Any]{
                    if let safeOriginal = safeImages["original"] as? [String:Any]{
                        newHotel.imageURL = safeOriginal["url"] as? String;
                    }
                }
            }
            return newHotel
        }).filter({ return $0 != nil});
        
        self.HotelData = HotelData as? Array<HotelModel>;
        print("Parsing is done !")
    }
}
