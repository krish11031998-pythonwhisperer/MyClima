//
//  CityViewController.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/12/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var CityTitle: UILabel!
    @IBOutlet weak var CityDesc: UILabel!
    @IBOutlet weak var AttractionsButton: UIButton!
    @IBOutlet weak var HotelsButton: UIButton!
    var attractionsList = Array<AttractionModel>();
    var attractionManager = Attractions();
    var city:CityModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI();
        attractionManager.delegate = self;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func GetHotels(_ sender: UIButton) {
    }
    
    @IBAction func GetAttractions(_ sender: UIButton) {
        if let safeCity = self.city{
            self.attractionManager.findAttractions((safeCity.latitude ?? 0.0), (safeCity.longitude ?? 0.0));
        }
        
    }
    func updateUI(){
        if let safeCity = city {
            self.CityTitle.text = safeCity.name ?? "CityName";
            self.CityDesc.text = safeCity.geo_description ?? "This is a great city";
            self.backGroundImage.downloaded(urlString: (safeCity.photo ?? ""));
            self.AttractionsButton.fancyButton(.black, .white);
            self.HotelsButton.fancyButton(.black, .white);
        }
    }
    
    func updateData(_ data:CityModel){
        self.city = data;
    }
}

// MARK: - UpdateAttractions

extension CityViewController: UpdateAttractions{
    
    func performAttractionUpdate(_ data: Any) {
        DispatchQueue.main.async {
             if let safeData = data as? Array<AttractionModel>{
                    self.attractionsList = safeData;
                }
            self.performSegue(withIdentifier: "goToAttraction", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAttraction"{
            if let destination = segue.destination as? AttractionViewController{
                destination.updateNavBarValue("Attractions", "MainDashboard")
                destination.setAttraction(self.attractionsList);
            }
        }
    }
}

