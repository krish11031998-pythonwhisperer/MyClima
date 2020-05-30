//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation



protocol Update{
    func performUIUpdate(_ data:WeatherModel);
    func didFailDuringRequest(_ error : Any);
    func didFailDuringDecoding(_ error:Error);
}

protocol UpdateAttractions{
    func performAttractionUpdate(_ data:Any);
}

protocol UpdateCity {
    func performCityUpdate(_ data:Any);
}

protocol UpdateHotel {
    func performHotelUpdate(_ data:Any);
}

extension UIButton{
    func roundedCorner(pixels: Double){
        var button = self;
        button.layer.cornerRadius = CGFloat(pixels);
        button.clipsToBounds = true;
    }
    
    func fancyButton(_ backGroundColor:UIColor = .clear,_ borderColor:UIColor = .clear){
        var button = self;
        button.backgroundColor = backgroundColor;
        button.layer.cornerRadius = 5;
        if backgroundColor == .black {
            button.titleLabel?.textColor = .white;
        }

        button.layer.borderWidth = 1;
        button.layer.borderColor = borderColor.cgColor;
    }
}

var imageCache = NSCache<NSString,UIImage>();
extension UIImageView {
    func downloaded(_ urlString:String) {
        if let url = URL(string: urlString){
            if let image = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage{
                self.image = image;
                return;
            }
            URLSession.shared.dataTask(with: url, completionHandler: {(data,response,error) in
                var finalImage:UIImage?;
                if error == nil , let safeData = data{
                        finalImage = UIImage(data: safeData)!;
                } else if error != nil{
                    print("There is an error :  \(error!)");
                    finalImage = nil;
                }
                DispatchQueue.main.async () { [weak self] in
                    self?.image = finalImage ?? UIImage(named: "light_background");
                    self?.contentMode = .scaleAspectFill;
                    if let safeImage = finalImage{
                        imageCache.setObject(safeImage, forKey: url.absoluteString as NSString);
                    }
                    
                }
                }).resume()
        }
    }
}

class WeatherViewController: UIViewController , UINavigationControllerDelegate{

    var icon_images = ["Rain":"cloud.rain","Drizzle":"cloud.drizle","Thunderstorm":"cloud.bolt","Snow":"snow","Clear":"sun.max.fill","Cloud":"cloud","Atmosphere":"cloud.fog"];
    var weatherManager = WeatherManager();
    var locationManager = CLLocationManager();
//    var attractionManager = Attractions();
    var cityManager = City();
    var lon:Double? = 0.0;
    var lat:Double? = 0.0;
    var destination:String? = "London";
    var cityData:CityModel?;
//    var attractionsList = Array<AttractionModel>();
    @IBOutlet weak var findHotel: UIButton!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var SearchField: UITextField!
    @IBAction func Search(_ sender: UIButton) {
        SearchField.endEditing(true);
        print(SearchField.text!);
        
        
    }
    @IBOutlet weak var mainBackground: UIImageView!;
    @IBAction func FindHotels(_ sender: UIButton) {
//        print("The self.lat \(self.lat) and self.lon \(self.lon) LINE 53");
//        self.attractionManager.findAttractions(self.lat ?? 0.0, self.lon ?? 0.0);
        self.cityManager.getCityDetails(city: (self.cityLabel.text!));
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated);
//        navigationController?.setToolbarHidden(true, animated: false);
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated);
//        navigationController?.setToolbarHidden(false, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.findHotel.roundedCorner(pixels: 10.5);
        locationManager.delegate = self;
        SearchField.delegate = self;
        weatherManager.delegate = self;
//        attractionManager.delegate = self;
        cityManager.delegate = self;
        locationManager.requestWhenInUseAuthorization();
        locationManager.requestLocation();
        self.checkTime();
    }
    
    @IBAction func presentLocation(_ sender: UIButton) {
        self.locationManager.requestLocation();
    }
    
    static func covertJSONToDict(data:String) -> [String:Any]? {
        if let safedata = data.data(using: .utf8){
            do{
                return try JSONSerialization.jsonObject(with: safedata, options: []) as? [String:Any]
            }catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
   
}

//MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true);
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else{
            textField.placeholder = "Type Something Pls";
            return false;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing is called");
        if(textField.text! != ""){
            self.destination = textField.text!.lowercased();
            weatherManager.destinationWeather(destination: textField.text!.lowercased());
        }
        textField.text = "";
    }
    
}


//MARK: - Update
extension WeatherViewController : Update {

        func checkTime(){
            let nowtime = Date().description.split(separator: " ")[1].split(separator: ":").map({(x) in Int(x)});
            if let hour = nowtime[0]{
                if(hour > 12){
                    print("changing the image now \(hour)");
                    self.mainBackground.image = #imageLiteral(resourceName: "dark_background");
                }
            }
        }
      
        func updateCity(name:String){
           self.cityLabel?.text = name;
       }
       
       func updateTemp(temp:String){
           self.temperatureLabel?.text = temp;
       }
       
       func updateCondition(condition:String){
           print("Condition : \(condition)");
           self.conditionImageView?.image = UIImage(systemName: self.icon_images[condition] ?? "sun.min");
       }
       
       func performUIUpdate(_ data:WeatherModel) {
           DispatchQueue.main.async {
               self.lon = Double(data.lon);
               self.lat =  Double(data.lat);
               print("lon:\(self.lon) and lat:\(self.lat)");
               self.updateCity(name: data.city);
               self.updateTemp(temp: data.temperature);
               self.updateCondition(condition: data.weatherCondition);
           }
       }
       
       func didFailDuringRequest(_ error: Any) {
           print("There was an error while running the server request -> \(error)");
       }
       
       func didFailDuringDecoding(_ error: Error) {
           print("There was an error while decoding the recieved object \(error)");
       }
}


//MARK: - CLLocation

extension WeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got the locations \(locations)");
        if let location = locations.last {
            self.lon = location.coordinate.longitude;
            self.lat = location.coordinate.latitude;
            print("The self.lat \(self.lat) and self.lon \(self.lon) LINE 176")
            let latitude = Int(location.coordinate.latitude);
            let longitude = Int(location.coordinate.longitude);
            weatherManager.destinationWeather(lattitude: latitude, longitude: longitude);
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error);
    }
}

// MARK: - Update City
extension WeatherViewController:UpdateCity{
    func performCityUpdate(_ data: Any) {
        DispatchQueue.main.async {
            if let safeCity = data as? CityModel{
                      self.cityData = safeCity;
                      print("Recieved data \(self.cityData)");
                    self.performSegue(withIdentifier: "goToCity", sender: self);
                  }

        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCity"{
            var destination = segue.destination as! CityViewController;
            if let safeCity = self.cityData {
                destination.updateData(safeCity);
            }
            
            
        }
    }
}
