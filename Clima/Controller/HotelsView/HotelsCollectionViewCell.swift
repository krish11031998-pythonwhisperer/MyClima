//
//  HotelsCollectionViewCell.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/15/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

extension UILabel {
    func updateDesign(_ font:String, _ size:CGFloat = 12.0, _ textColor:UIColor = .black){
        self.font = UIFont(name: font, size: 15)
        self.textColor = textColor;
    }
}


class HotelsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var HotelRatingLabel: UILabel!
    @IBOutlet weak var PriceLevelLabel: UILabel!
    @IBOutlet weak var CView: UIView!
    
    
    func updateElements(_ data:HotelModel?){
        guard let safeHotel = data else {return}
        print("Updating HotelCell");
        DispatchQueue.main.async {
            self.NameLabel.text = safeHotel.name ?? "Name";
            self.RatingLabel.text = safeHotel.rating ?? "0";
            self.HotelRatingLabel.text = safeHotel.hotel_class ?? "0.0";
            self.PriceLevelLabel.text = safeHotel.price_level ?? "$";
            self.backGround.downloaded(safeHotel.imageURL ?? "")
            self.NameLabel.updateDesign("Avenir Next", 15.0, .white);
            self.RatingLabel.updateDesign("Avenir Next", 11.0, .white);
            self.HotelRatingLabel.updateDesign("Avenir Next", 11.0, .white);
            self.PriceLevelLabel.updateDesign("Avenir Next", 11.0, .white);
            self.backGround.roundedcorner();
            self.CView.roundedcorner();
        }
        
    }
    
    
    
    
}
