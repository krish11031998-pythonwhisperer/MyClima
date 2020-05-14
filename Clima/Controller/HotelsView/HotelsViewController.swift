//
//  HotelsViewController.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/15/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class HotelsViewController: UIViewController {

    @IBOutlet weak var HotelsCollection: UICollectionView!
    var Hotels:Array<HotelModel>?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HotelsCollection.dataSource = self;
        // Do any additional setup after loading the view.
    }
    
    func updateData(_ data:Any){
        guard let safeHotels = data as? Array<HotelModel> else { return }
        self.Hotels = safeHotels;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HotelsViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Hotels!.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCell", for: indexPath) as! HotelsCollectionViewCell;
        
        let hotel = self.Hotels![indexPath.item];
        
        cell.updateElements(hotel);
        
        return cell
    }
}
