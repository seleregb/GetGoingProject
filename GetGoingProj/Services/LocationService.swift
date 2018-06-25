//
//  LocationService.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-25.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation
import CoreLocation


class LocationService: NSObject, CLLocationManagerDelegate {
    
    
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.delegate = self
    }
    
    // MARK: - CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
    
    }
}
