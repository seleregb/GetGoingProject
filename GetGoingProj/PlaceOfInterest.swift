//
//  PlaceOfInterest.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-18.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation
import CoreLocation

class PlaceOfInterest {
    
    var id: String
    var name: String
    var rating: Double?
    var formattedAddress: String?
    var iconImageView: String?
    var placeId: String?
    var website: String?
    var formattedPhoneNumber: String?
    var location: CLLocation?
    var photoArray: Array<[String: Any]>?
    var typesArray: Array<String>?
    
    init?(json: [String: Any]) {
        
        guard let id = json["id"] as? String else {
            return nil
        }
        guard let name = json["name"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.rating = json["rating"] as? Double
        self.formattedAddress = json["formatted_address"] as? String
        self.iconImageView = json["icon"] as? String
        self.placeId = json["place_id"] as? String
        self.website = json["website"] as? String
        self.formattedPhoneNumber = json["formatted_phone_number"] as? String
        
        if let geometry = json["geometry"] as? [String: Any] {
            if let locationCoordinate = geometry["location"] as? [String: Double] {
                if let latitude = locationCoordinate["lat"], let longitude = locationCoordinate["lng"] {
                    self.location = CLLocation(latitude: latitude, longitude: longitude)
                }
            }
        }
        
        self.photoArray = json["photos"] as? Array<[String: Any]>
        
        self.typesArray = json["types"] as? Array<String>
        
    }
    
}
