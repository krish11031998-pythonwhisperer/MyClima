//
//  AttractionDetailCollectionViewCell.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/16/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class AttractionDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var OfferLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backGroundImage: UIImageView!
    
    func updateElements(_ data:[String:Any]){
        self.OfferLabel.text = data["offerTitle"] as? String;
        self.priceLabel.text = data["price"] as? String;
        guard let safeURLString = data["urlString"] as? String else {
            self.backgroundView?.backgroundColor = .systemPink
            return
        }
        self.backGroundImage.downloaded(safeURLString);
        self.backgroundView?.roundedcorner();
    }
    
}
