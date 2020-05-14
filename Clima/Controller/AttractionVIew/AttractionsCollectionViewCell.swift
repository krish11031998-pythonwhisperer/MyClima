//
//  AttractionsCollectionViewCell.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/13/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

extension UIView {
    func roundedcorner(_ pixels:CGFloat=10.0){
        self.layer.cornerRadius = pixels;
        self.layer.masksToBounds = true;
    }
}


import UIKit

class AttractionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainHeader: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var CostLabel: UILabel!
    @IBOutlet weak var ExploreButton: UIButton!
    @IBAction func Explore(_ sender: UIButton) {
    }
    @IBOutlet weak var backGround: UIImageView!
    @IBOutlet weak var attractionView: UIView!
    var attractionData:AttractionModel?;
    
    func updateData(_ data:AttractionModel){
        self.attractionData = data;
        self.updateUI();
    }
    
    func updateUI(){
        if let safeAttraction = self.attractionData{
            DispatchQueue.main.async{
                if let url = safeAttraction.offers?.offer_list?[0].image_url as String?{
                    self.backGround.downloaded(url)
                }
                self.mainHeader.text = safeAttraction.name ?? "Attraction";
                self.AddressLabel.text = safeAttraction.address ?? "Address";
                self.CostLabel.text = safeAttraction.offers?.lowest_price ?? "0.0";
                self.ExploreButton.fancyButton(.black, .black);
                self.backGround.roundedcorner();
                self.attractionView.roundedcorner();
            }
            
            
        }
        
    }
    
    
    
    
}
