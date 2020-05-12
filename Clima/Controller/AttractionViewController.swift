//
//  AttractionViewController.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit




class AttractionViewController: UIViewController {

    @IBOutlet weak var AttractionTable: UITableView!
    @IBOutlet weak var NavBar: UINavigationItem!
    @IBOutlet weak var CityImage: UIImageView!
    @IBOutlet weak var CityLabel: UILabel!
    var navBarTitle:String?;
    var cityImage:String?;
    var cityName:String?;
    var backTitle:String?;
    var attractionCells = Array<Attraction>();
    override func viewDidLoad() {
        super.viewDidLoad()
        AttractionTable.delegate = self;
        AttractionTable.dataSource = self;
        self.CityImage.downloaded(urlString: self.cityImage!);
        self.CityLabel.text = self.cityName ?? "Label";
        self.updateNavBar();
        // Do any additional setup after loading the view.
    }
    
    func updateNavBar(){
        self.NavBar.title = self.navBarTitle ?? "Default";
        self.NavBar.backBarButtonItem?.title = self.backTitle ?? "Back";
    }
    
    func updateNavBarValue(_ title:String, _ back:String){
        self.navBarTitle = title;
        self.backTitle = back;
    }

    func updateCity(_ data:CityModel){
        print(data);
        if let safePhoto = data.photo{
            print("safePhoto: \(safePhoto)");
            self.cityImage = safePhoto;
        }
        if let safeName = data.name{
            self.cityName = safeName;
        }
//        self.CityImage.downloaded(urlString: data.photo ?? "");
        
    }
    
    func setAttraction(_ attractions: Array<AttractionModel>){
        print("Recieved Attractions list \(attractions.count)");
        self.attractionCells = attractions.map({ (attraction) -> Attraction in
            var newCell = Attraction(image: #imageLiteral(resourceName: "testImage"), title: (attraction.name ?? "No Name"), area: (attraction.address ?? "NA"), price: (attraction.offers?.lowest_price ?? "0.0"), imgURL: (attraction.offers?.offer_list?[0].image_url ?? ""));
            return newCell;
        })
    }
}

extension AttractionViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attractionCells.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attraction = self.attractionCells[indexPath.row];
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "AttractionCell") as? AttractionTableViewCell)!;
        
        cell.updateElements(attraction.title, attraction.image, attraction.area, attraction.price, attraction.imgURL);
        
        return cell
    }
}
