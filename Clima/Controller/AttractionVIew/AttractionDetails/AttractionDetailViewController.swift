//
//  AttractionDetailViewController.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/16/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import MapKit


class AttractionDetailViewController: UIViewController {

    @IBOutlet weak var MainMap: MKMapView!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var OffersCollection: UICollectionView!
    var locationManager = CLLocationManager();
    var regionMeters:Double = 1000;
    var prevLocation:CLLocation?;
    var attraction:AttractionModel?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.OffersCollection.dataSource = self;
        self.updateUI();
        self.MainMap.delegate = self;
        self.locationManager.delegate = self;
        self.setupLocationManager();
        self.checkDesiredLocation();
        // Do any additional setup after loading the view.
    }
    
    func updateElement(_ data:AttractionModel){
        self.attraction = data;
    }
    
    func updateUI(){
        guard let safeData = self.attraction else {return}
        self.NameLabel.text = safeData.name ?? "";
        self.AddressLabel.text = safeData.address ?? "";
    }
    
    
    func checkDesiredLocation(){
        if let safeAttraction = self.attraction {
            self.setMapRegion(CLLocationCoordinate2D(latitude: (safeAttraction.lat ?? 0.0) , longitude: (safeAttraction.lon ?? 0.0)));
            self.prevLocation = self.getCenterLocation();
        }else{
            self.checkLocationServices();
        }
    }
    
    func getCenterLocation() -> CLLocation{
        return CLLocation(latitude: self.MainMap.centerCoordinate.latitude, longitude: self.MainMap.centerCoordinate.longitude);
    }
    
    func setMapRegion(_ center:CLLocationCoordinate2D){
        self.MainMap.setRegion(MKCoordinateRegion(center: center, latitudinalMeters: self.regionMeters, longitudinalMeters: self.regionMeters), animated: true);
    }
    
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            self.setupLocationManager();
            self.checkLocationAuthorization();
            //setup our location manager
        }else{
            // SHow alert
        }
    }
    
    func centerLocation(){
        if let safeCoordinates = locationManager.location?.coordinate{
            self.setMapRegion(safeCoordinates);
        }
    }
    
    func setupLocationManager(){
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }


    func startTrackingUserLocation(){
        MainMap.showsUserLocation = true;
        self.centerLocation();
        self.locationManager.startUpdatingLocation();
        self.prevLocation = self.getCenterLocation();

    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
            case .authorizedWhenInUse:
                self.startTrackingUserLocation();
            case .authorizedAlways:
                self.startTrackingUserLocation();
            case .denied:
                break;
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization();
                break;
            case .restricted:
                break;
            default:
                print("You have run into default");
        }
    }
    
    
    
}


// MARK: - Offers CollectionView
extension AttractionDetailViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let safeAttraction = self.attraction?.offers?.offer_list else {return 1}
        return safeAttraction.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let safeOffers = self.attraction?.offers?.offer_list else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attractionDetailCell", for: indexPath) as! AttractionDetailCollectionViewCell
            cell.updateElements(["offerTitle":"No Offers", "price":"N/A"]);
            
            return cell}
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attractionDetailCell", for: indexPath) as! AttractionDetailCollectionViewCell
        
        let cellData = safeOffers[indexPath.item];
        cell.updateElements(["offerTitle": (cellData.title ?? "Title"), "price": (cellData.price ?? "0.0"), "urlString" : (cellData.image_url ?? "")])
        
        return cell
    }
    
    
}

// MARK: - MapView

extension AttractionDetailViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        var center = self.getCenterLocation();
        let geoCoder = CLGeocoder();
        
        guard let safePrevLocation = self.prevLocation , center.distance(from: safePrevLocation) > 50 else { return }
        self.prevLocation = center;
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks,error) in
            if let _ = error{
                print("There was an error");
                return;
            }
            
            guard let safePlacemark = placemarks?.first else { return }
            
            var streetName = safePlacemark.thoroughfare ?? "";
            var streetNumber = safePlacemark.subThoroughfare ?? "";
            print("street")
            DispatchQueue.main.async{
                self?.AddressLabel.text = "\(streetNumber) \(streetName)";
            }
        }
    }
}


// MARK: - CLLocation

extension AttractionDetailViewController : CLLocationManagerDelegate{
    
}
