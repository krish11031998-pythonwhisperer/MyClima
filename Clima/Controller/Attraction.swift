//
//  Attraction.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import UIKit

class Attraction{
    var image:UIImage;
    var title:String;
    var area:String;
    var price:String;
    var imgURL:String = "";
    init(image:UIImage,title:String,area:String,price:String,imgURL:String = ""){
        self.image = image;
        self.title = title;
        self.area = area;
        self.price = price;
        if imgURL != ""{
            self.imgURL = imgURL;
        }
    }
}
