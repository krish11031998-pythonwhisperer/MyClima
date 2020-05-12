//
//  AttractionTableViewCell.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloaded(urlString:String){
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url, completionHandler: {(data,response,error) -> Void in
                if let safeData = data{
                    DispatchQueue.main.async {
                        self.image = UIImage(data: safeData);
                    }
                }
                }).resume();
        }
    }
}


class AttractionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var AttractionImage: UIImageView!
    @IBOutlet weak var AttractionLabel: UILabel!
    @IBOutlet weak var AreaLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var ExploreButton: UIButton!
    @IBOutlet weak var BookButton: UIButton!
    
    func updateButtons(){
        self.ExploreButton.fancyButton(.clear,.red);
        self.BookButton.fancyButton(.black, .white);
    }
    
    func updateElements(_ label:String, _ image:UIImage, _ Area:String, _ Price:String, _ imageURL:String = ""){
        self.updateButtons();
        self.AttractionLabel.text = label;
        self.AreaLabel.text = Area;
        self.PriceLabel.text = Price;
        if imageURL == ""{
            self.AttractionImage.image = image;
        }else{
            self.AttractionImage.downloaded(urlString: imageURL);
        }
    }
}
