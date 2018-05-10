//
//  MainController+Location.swift
//  iCab
//
//  Created by Jaksa Tomovic on 10/05/2018.
//  Copyright © 2018 Jakša Tomović. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

extension MainController: CLLocationManagerDelegate {
    
    func monitorLocation() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        //        UserDefaults.standard.set(currentLocation.coordinate.latitude, forKey: Settings.CURRENT_LATITUDE)
        //        UserDefaults.standard.set(currentLocation.coordinate.longitude, forKey: Settings.CURRENT_LONGITUDE)
        getPlace(lat: currentLocation.coordinate.latitude, lng: currentLocation.coordinate.longitude)
        
    }
    
    func getPlace(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lng)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard let placeMark: CLPlacemark = placemarks?[0] else { return }
            guard let city = placeMark.locality else { return }
            print(city as Any)
        })
        
    }
    
}
