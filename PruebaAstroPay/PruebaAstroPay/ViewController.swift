//
//  ViewController.swift
//  PruebaAstroPay
//
//  Created by Sebastian Leonardi on 12/7/18.
//  Copyright © 2018 Sebastian Leonardi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate, WeatherControllerDelegate  {

    @IBOutlet weak var imgIcon: UIImageView!;
    
    @IBOutlet weak var lblCity: UILabel!;
    @IBOutlet weak var lblTemperature: UILabel!;
    @IBOutlet weak var lblMinMaxTemp: UILabel!;
    @IBOutlet weak var lblWeather: UILabel!;
    @IBOutlet weak var lblDescription: UILabel!;
    
    @IBOutlet weak var lblHumidity: UILabel!;
    @IBOutlet weak var lblPressure: UILabel!;
    @IBOutlet weak var lblWindSpeed: UILabel!;
    
    @IBOutlet weak var txtDownPicker: UITextField!;
    
    private var locationManager: CLLocationManager!;
    
    private var weatherController: WeatherController!;
    private let cityOptions = [("Montevideo", "Montevideo,UY"), ("Londres", "London,GB"), ("San Pablo", "Sao%20Paulo,BR"), ("Buenos Aires", "Buenos%20Aires,AR"), ("Munich", "Muenchen,DE")];
    
    // MARK: Life Cycle
    // ----------------
    override func viewDidLoad() {
        super.viewDidLoad();
        
        locationManager = CLLocationManager();
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        let pickerView = UIPickerView();
        pickerView.delegate = self;
        txtDownPicker.inputView = pickerView;
        txtDownPicker.text = cityOptions[0].0;
        
        lblTemperature.text = "0°";
        lblMinMaxTemp.text = "0°/0°";
        lblWeather.text = "";
        lblDescription.text = "";
        
        lblHumidity.text = "0 %";
        lblPressure.text = "0 hPA";
        lblWindSpeed.text = "0 m/s";
        
        weatherController = WeatherController(delegate: self);
        weatherController.getWeather(city: cityOptions[0].1);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    // MARK: WeatherControllerDelegate methods
    // ---------------------------------------
    func weatherControllerDelegateOnWeatherSuccess(weather: Weather) {
        
        weatherController.getWeatherIcon(icon: weather.icon);
        
        DispatchQueue.main.async() {
            self.lblCity.text = weather.name;
            self.lblTemperature.text = "\(weather.temperature)°";
            self.lblMinMaxTemp.text = "\(weather.temperatureMin)°/\(weather.temperatureMax)°";
            self.lblWeather.text = weather.weather;
            self.lblDescription.text = weather.description;
            
            self.lblHumidity.text = "\(weather.humidity) %";
            self.lblPressure.text = "\(weather.pressure) hPA";
            self.lblWindSpeed.text = "\(weather.windSpeed) m/s";
        }
    }
    
    func weatherControllerDelegateOnImageSuccess(image: UIImage) {
        DispatchQueue.main.async() {
            self.imgIcon.image = image;
        }
    }
    
    func weatherControllerDelegateOnError(error: Error) {
        DispatchQueue.main.async() {
            self.showErrorAlert(title: "Error loading weather",
                                message: error.localizedDescription);
        }
    }
    
    // MARK: - UIPickerViewDataSource
    // ------------------------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityOptions.count;
    }
    
    // MARK: - UIPickerViewDelegate
    // ----------------------------
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityOptions[row].0;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weatherController.getWeather(city: cityOptions[row].1);
        DispatchQueue.main.async() {
            self.txtDownPicker.text = self.cityOptions[row].0;
            self.view.endEditing(true);
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    // ---------------------------------
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation();
        
        let newLocation = locations.last!;
        weatherController.getWeather(location: newLocation);
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)");
    }
    
    // MARK: - Button Actions
    // -----------------------
    @IBAction func btnGetCurrentLocationAction() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are disabled on your device");
            return;
        }
        
        let authStatus = CLLocationManager.authorizationStatus();
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                print("This app is not authorized to use your location");
                break;
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization();
                break;
            default:
                break;
            }
            return
        }
        
        locationManager.startUpdatingLocation();
    }
    
    // MARK: - Private methods
    // -----------------------
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        );
        let okAction = UIAlertAction(
            title: "Ok",
            style:  .default,
            handler: nil
        );
        alert.addAction(okAction);
        
        present(alert, animated: true, completion: nil);
    }
}

