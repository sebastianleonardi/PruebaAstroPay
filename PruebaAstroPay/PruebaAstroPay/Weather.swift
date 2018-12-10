//
//  Weather.swift
//  PruebaAstroPay
//
//  Created by Sebastian Leonardi on 12/8/18.
//  Copyright © 2018 Sebastian Leonardi. All rights reserved.
//

import Foundation

class Weather {
    let name: String;
    let weather: String;
    let description: String;
    let icon: String;
    let temperature: Double;
    let temperatureMin: Double;
    let temperatureMax: Double;
    let humidity: Int;
    let pressure: Int;
    let windSpeed: Double;
    
    init(data: [String: AnyObject]) {
        name = data["name"] as! String;

        let weatherDict = data["weather"]![0] as! [String: AnyObject];
        weather = weatherDict["main"] as! String;
        description = weatherDict["description"] as! String;
        icon = weatherDict["icon"] as! String;
        
        let mainDict = data["main"] as! [String: AnyObject];
        temperature = mainDict["temp"] as! Double;
        temperatureMin = mainDict["temp_min"] as! Double;
        temperatureMax = mainDict["temp_max"] as! Double;
        humidity = mainDict["humidity"] as! Int;
        pressure = mainDict["pressure"] as! Int;
        
        let windDict = data["wind"] as! [String: AnyObject];
        windSpeed = windDict["speed"] as! Double;
    }
}
