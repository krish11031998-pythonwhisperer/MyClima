//
//  AttractionsModel.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation


struct AttractionModel : Codable{
    
    var name:String?;
    var num_reviews:String?;
    var location_string:String?;
    var ranking:String?;
    var distance:String?;
    var rating:String?;
    var phone:String?;
    var address:String?;
    var booking:String?;
    var offers: offer_group?;
    
    mutating func parseBooking(_ obj:Any){
        if let safeDict = obj as? [String:Any]{
            self.booking = safeDict["url"] as? String;
        }
    }
    
    mutating func parseOffer(_ obj:Any){

        if let safeDict = obj as? [String:Any]{
            var newOfferGroup = offer_group();
            newOfferGroup.lowest_price = safeDict["lowest_price"] as? String;
            if let safeofferlist = safeDict["offer_list"] as? Array<[String:Any]>{
                var newOfferList = Array<offer>()
                for safeoffer in safeofferlist{
                    var newOffer = offer()
                    newOffer.image_url = safeoffer["image_url"] as? String;
                    newOffer.price = safeoffer["price"] as? String;
                    newOffer.rounded_up_price = safeoffer["rounded_up_price"] as? String;
                    newOffer.title = safeoffer["title"] as? String;
                    newOffer.url = safeoffer["url"] as? String;
                    newOfferList.append(newOffer);
                }
                newOfferGroup.offer_list = newOfferList;
            }
            self.offers = newOfferGroup;
        }
    }
}

struct booking : Codable{
    var url:URL?;
}


struct offer_group: Codable{
    var lowest_price:String?;
    var offer_list : [offer]?;
    
}

struct offer : Codable {
    var url:String?;
    var price:String?;
    var rounded_up_price:String?;
    var image_url: String?;
    var title:String?;
    
}



