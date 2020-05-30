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

protocol AttractionSegue{
    
    func performSegueToAttraction( _ data:AttractionModel)
}

import UIKit

class AttractionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainHeader: UILabel!
    @IBOutlet weak var ExploreButton: UIButton!
    var delegate:AttractionSegue?;
    @IBAction func Explore(_ sender: UIButton) {
        guard let safeAttraction = attractionData else {
            print("No data available!");
            return
        }
        self.delegate?.performSegueToAttraction(safeAttraction);
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
                if let url = safeAttraction.photo as String?{
                    self.backGround.downloaded(url)
                }
                self.mainHeader.text = safeAttraction.name ?? "Attraction";
                self.ExploreButton.fancyButton(.black, .black);
                self.backGround.roundedcorner();
//                self.attractionView.roundedcorner();
            }
            
            
        }
        
    }
    
    
    
    
}
