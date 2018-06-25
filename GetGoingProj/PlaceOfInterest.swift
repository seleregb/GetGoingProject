//
//  PlaceOfInterest.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-18.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation

class PlaceOfInterest {
    
    var id: String
    var name: String
    var rating: Double?
    var formattedAddress: String?
    var geometry: [String: [String: Any]]?
    var iconImageView: String?
    var placeId: String?
    var website: String?
    var formattedPhoneNumber: String?
    
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
        self.geometry = json["geometry"] as? [String: [String: Any]]
        self.iconImageView = json["icon"] as? String
        self.placeId = json["place_id"] as? String
        self.website = json["website"] as? String
        self.formattedPhoneNumber = json["formatted_phone_number"] as? String
        
    }
    
}
