//
//  HotelsViewController.swift
//  Clima
//
//  Created by Krishna Venkatramani on 5/15/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HotelsViewController: UIViewController {

    @IBOutlet weak var MainMap: MKMapView!
    @IBOutlet weak var HotelsCollection: UICollectionView!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var LocationButton: UIButton!
    @IBOutlet weak var GOButton: UIButton!
    var Hotels:Array<HotelModel>?;
    let locationManager = CLLocationManager();
    var regionMeters:Double = 10000;
    var prevLocation:CLLocation?;
    var baseLocation:CLLocationCoordinate2D?;
    var destinationLocation:CLLocationCoordinate2D?;
    var allDirections:Array<MKDirections>?;
    var city:CityModel?;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HotelsCollection.dataSource = self;
        self.MainMap.delegate = self;
        self.setupLocationmanager();
        self.checkDesiredLocation();
        self.GOButton.roundedCorner(pixels: Double(((GOButton.frame.width/2.0) as! CGFloat)))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        self.LocationButton.imageView?.image = UIImage(systemName : "location.fill");
        startTrackingUserLocation();
    }
    
    
    
    func getDirections(){
        guard let safeBase = self.baseLocation , let safeDestination = self.destinationLocation else {return}
        
        var request = self.RouteRequest(from: safeBase, to: safeDestination)
        
        let direction = MKDirections(request: request);
        self.removeDirections(withNew: direction)
        direction.calculate { [unowned self] (response,error) in
            
            guard let safeResponse = response else {
                
                print("There is an error");
                return
                
            }
            
            for route in safeResponse.routes{
                self.MainMap.addOverlay(route.polyline);
                self.MainMap.setVisibleMapRect(route.polyline.boundingMapRect, animated: true);
            }
            
                
        }
        
    }
    
    func removeDirections(withNew direction:MKDirections){
        self.MainMap.removeOverlays(self.MainMap.overlays)
        self.allDirections?.append(direction)
        let _  = self.allDirections?.map({ (dir) in
            dir.cancel();
        });
        
    }
    
    
    func RouteRequest(from base:CLLocationCoordinate2D, to destination:CLLocationCoordinate2D) -> MKDirections.Request{
        
        let Base = MKPlacemark(coordinate: base);
        let Destination = MKPlacemark(coordinate: destination);
        
        let request = MKDirections.Request();
        request.source = MKMapItem(placemark: Base);
        request.destination = MKMapItem(placemark: Destination);
        request.transportType = .automobile;
        request.requestsAlternateRoutes = true;
        
        return request
        
        
    }
    
    @IBAction func getDestinationLocation(_ sender: UIButton) {
        self.checkDesiredLocation();
    }
    
    func checkDesiredLocation(){
        if let safecity = self.city {
            let center = CLLocationCoordinate2D(latitude: safecity.latitude!, longitude: safecity.longitude!);
            print("\(safecity) and \(center)");
            self.baseLocation = center;
            self.setMapLocation(center);
            self.prevLocation = self.getCenterLocation(for: self.MainMap);
        }else{
            self.checkLocationServices();
        }
    }
    
    @IBAction func goDestination(_ sender: UIButton){
        let destination = self.getCenterLocation(for: MainMap);
        self.destinationLocation = CLLocationCoordinate2D(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude);
        self.getDirections();
        
    }
    
    
    func setMapLocation(_ center: CLLocationCoordinate2D){
        let region = MKCoordinateRegion.init(center : center, latitudinalMeters: self.regionMeters, longitudinalMeters: self.regionMeters);
        self.MainMap.setRegion(region, animated: true);
    }
    
    func setupLocationmanager(){
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            self.setupLocationmanager();
            self.checkLocationAuthorization();
            //setup our location manager
        }else{
            // SHow alert
        }
    }
    
    func startTrackingUserLocation(){
        self.MainMap.showsUserLocation = true;
        self.centerLocation();
        self.locationManager.startUpdatingLocation();
            
        let baseLocation = self.getCenterLocation(for: MainMap);
        self.baseLocation = CLLocationCoordinate2D(latitude: baseLocation.coordinate.latitude, longitude: baseLocation.coordinate.longitude);
        self.prevLocation = self.getCenterLocation(for: MainMap);
    }
    
    func centerLocation(){
        if let safeLocation = locationManager.location?.coordinate {
            self.setMapLocation(safeLocation);
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
            case .authorizedWhenInUse:
                self.startTrackingUserLocation();
            case .authorizedAlways:
                MainMap.showsUserLocation = true;
                self.centerLocation();
                break;
            case .denied:
                break;
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization();
                break;
            case .restricted:
                break;
            default:
                print("You have run into default");
        }
    }
    
    func updateData(_ data:Any,_ cityData:CityModel?=nil){
        guard let safeHotels = data as? Array<HotelModel> else { return }
        self.Hotels = safeHotels;
        guard let safeCity = cityData else {return}
        self.city = safeCity;
    }
    
    func getCenterLocation(for mapView:MKMapView) -> CLLocation{
        var latitude = mapView.centerCoordinate.latitude;
        var longitude = mapView.centerCoordinate.longitude;
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    

}

// MARK: - HotelCollectionViewDataSource
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

// MARK: - MapKit

extension HotelsViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        var center = self.getCenterLocation(for: mapView);
        let geoCoder = CLGeocoder();
        
        
        guard let safePrevLocation = self.prevLocation , center.distance(from: safePrevLocation) > 50 else { return }
        self.baseLocation = CLLocationCoordinate2D(latitude: self.prevLocation?.coordinate.latitude ?? 0.0, longitude: self.prevLocation?.coordinate.longitude ?? 0.0);
        self.prevLocation = center
        
        geoCoder.cancelGeocode();
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            
            if let _ = error{
                print("There was an error");
            }
            
            guard let placemark = placemarks?.first else { return };
            var streetName = placemark.thoroughfare ?? ""
            var streetNumber = placemark.subThoroughfare ?? "";
            
            
            DispatchQueue.main.async {
                self?.AddressLabel.text = "\(streetNumber) \(streetName)";
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline);
        renderer.strokeColor = .systemBlue;
        
        return renderer;
    }
}


// MARK: - CoreLcoation

extension HotelsViewController : CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//        let region = MKCoordinateRegion.init(center : CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: self.regionMeters, longitudinalMeters: self.regionMeters);
//        MainMap.setRegion(region, animated: true);
//
//
//    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        self.checkLocationAuthorization();
//    }
}
