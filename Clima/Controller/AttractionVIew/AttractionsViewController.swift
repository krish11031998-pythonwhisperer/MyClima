//
//  AttractionsViewController.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/13/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class AttractionsViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var AttractionCollection: UICollectionView!
    var allAttractions:Array<AttractionModel>?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AttractionCollection.dataSource = self;
        self.navBar.title = "Attractions";
        self.navBar.backBarButtonItem?.title = "City"

    }
    
    func updateCollectionView(){
        let scale:CGFloat = 0.6
        let maxSize = UIScreen.main.bounds.size;
        let cellWidth = floor(maxSize.width * scale);
        let cellHeight = floor(maxSize.height * scale);
        let insetX = (view.bounds.width - cellWidth)/2.0;
        let insetY = (view.bounds.height - cellHeight)/2.0;
        let layout = self.AttractionCollection.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight);
        self.AttractionCollection.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX);
    }
    
    func updateAttractions(_ data:Array<AttractionModel>){
        self.allAttractions = data;
        print("Recieved the data");
    }

}


extension AttractionsViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allAttractions!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttractionCell", for: indexPath) as! AttractionsCollectionViewCell;
        let attraction = self.allAttractions![indexPath.item];
        
        cell.updateData(attraction);
        
        return cell;
    }
}

extension AttractionsViewController : UIScrollViewDelegate, UICollectionViewDelegate{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.AttractionCollection!.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing;
        var offset = targetContentOffset.pointee;
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing;
        let roundedIndex = round(index);
        
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top);
        
        targetContentOffset.pointee = offset;
        
        
    }
}
