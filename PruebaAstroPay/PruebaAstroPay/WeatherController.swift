//
//  WeatherController.swift
//  PruebaAstroPay
//
//  Created by Sebastian Leonardi on 12/7/18.
//  Copyright © 2018 Sebastian Leonardi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherControllerDelegate {
    func weatherControllerDelegateOnWeatherSuccess(weather: Weather);
    func weatherControllerDelegateOnImageSuccess(image: UIImage);
    func weatherControllerDelegateOnError(error: Error);
}

class WeatherController {
    
    private let apiKey = "0e6bf6aeb54cfda370aa1e3f960e5d25";
    private let weatherURL = "http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@&units=metric";
    private let weatherURLByCoord = "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@&units=metric";
    private let iconsURL = "http://openweathermap.org/img/w/%@.png";
    
    private let delegate: WeatherControllerDelegate;
    
    init(delegate: WeatherControllerDelegate) {
        self.delegate = delegate;
    }
    
    func getWeather(city: String) {
        print("ASTROPAY - Getting weather: " + city);
        
        let fullUrl = String(format: weatherURL, city, apiKey);
        let requestURL = URL(string: fullUrl)!;
        
        let session = URLSession.shared;
        let task = session.dataTask(with: requestURL) {
            (data, response, error) in
            if let error = error {
                print("ASTROPAY - Error: " + error.localizedDescription);
                self.delegate.weatherControllerDelegateOnError(error: error);
            }
            else {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject];
                    
                    let weather = Weather(data: data);
                    self.delegate.weatherControllerDelegateOnWeatherSuccess(weather: weather);
                }
                catch let error {
                    print("ASTROPAY - Error: " + error.localizedDescription);
                    self.delegate.weatherControllerDelegateOnError(error: error);
                }
            }
        }
        task.resume()
    }
    
    func getWeather(location: CLLocation) {
        print("ASTROPAY - Getting weather: " + "\(location.coordinate.latitude)" + ";" + "\(location.coordinate.longitude)");
        
        let fullUrl = String(format: weatherURLByCoord, location.coordinate.latitude, location.coordinate.longitude, apiKey);
        let requestURL = URL(string: fullUrl)!;
        
        let session = URLSession.shared;
        let task = session.dataTask(with: requestURL) {
            (data, response, error) in
            if let error = error {
                print("ASTROPAY - Error: " + error.localizedDescription);
                self.delegate.weatherControllerDelegateOnError(error: error);
            }
            else {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject];
                    
                    let weather = Weather(data: data);
                    self.delegate.weatherControllerDelegateOnWeatherSuccess(weather: weather);
                }
                catch let error {
                    print("ASTROPAY - Error: " + error.localizedDescription);
                    self.delegate.weatherControllerDelegateOnError(error: error);
                }
            }
        }
        task.resume()
    }
    
    func getWeatherIcon(icon: String) {
        let fullUrl = String(format: iconsURL, icon);
        let requestURL = URL(string: fullUrl)!;
        
        let session = URLSession.shared;
        let task = session.dataTask(with: requestURL) {
            (data, response, error) in
            if let error = error {
                print("ASTROPAY - Error: " + error.localizedDescription);
                self.delegate.weatherControllerDelegateOnError(error: error);
            }
            else {
                var image: UIImage;
                if let imageData = data {
                    image = UIImage(data: imageData)!;
                }
                else {
                    image = UIImage(named: "icon_no_image.png")!;
                }
                self.delegate.weatherControllerDelegateOnImageSuccess(image: image);
            }
        }
        
        task.resume()
    }
}
