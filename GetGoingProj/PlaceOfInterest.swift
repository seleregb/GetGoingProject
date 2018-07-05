//
//  PlaceOfInterest.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-18.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation
import CoreLocation

// NSCoding is a protocol
class PlaceOfInterest: NSObject, NSCoding {
    
    struct PropertyKey {
        static let idKey = "id"
        static let nameKey = "name"
        static let ratingKey = "rating"
        static let iconKey = "icon"
        static let latKey = "lat"
        static let lngKey = "lng"
        static let photoReferenceKey = "photoReference"
        static let maxWidthKey = "maxWidth"
        static let typesKey = "types"
        static let vicinityKey = "vicinity"
        static let formattedAddressKey = "formattedAddress"
        static let placeKey = "place_id"
    }
    
    var id: String
    var name: String
    var rating: Double?
    var formattedAddress: String?
    var iconUrl: String?
    var placeId: String?
    var website: String?
    var formattedPhoneNumber: String?
    var location: CLLocation?
    var photoReference: String?
    var types: [String]?
    var vicinity: String?
    var maxWidth: Int?
    var open_now: Bool?
    
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
        self.iconUrl = json["icon"] as? String
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
        
        if let photos = json["photos"] as? [[String: Any]] {
            if !photos.isEmpty {
                self.photoReference = photos.first!["photo_reference"] as? String
                self.maxWidth = photos.first!["width"] as? Int
            }
        }
        
        self.types = json["types"] as? [String]
        self.vicinity = json["vicinity"] as? String
        
        if let open_hours = json["opening_hours"] as? [String: Any] {
            if let placeIsOpen = open_hours["open_now"] as? Bool {
                self.open_now = placeIsOpen
            }
        }
    }
    
    init(id: String, name: String, placeId: String, rating: Double, icon: String, photoReference: String, maxWidth: Int, types: Array<String>, vicinity: String, formattedAddress: String) {
        self.id = id
        self.name = name
        self.placeId = placeId
        self.rating = rating
        self.iconUrl = icon
        self.photoReference = photoReference
        self.maxWidth = maxWidth
        self.types = types
        self.vicinity = vicinity
        self.formattedAddress = formattedAddress
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.idKey)
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(placeId, forKey: PropertyKey.placeKey)
        aCoder.encode(rating, forKey: PropertyKey.ratingKey)
        aCoder.encode(iconUrl, forKey: PropertyKey.iconKey)
        aCoder.encode(photoReference, forKey: PropertyKey.photoReferenceKey)
        aCoder.encode(maxWidth, forKey: PropertyKey.maxWidthKey)
        aCoder.encode(types, forKey: PropertyKey.typesKey)
        aCoder.encode(vicinity, forKey: PropertyKey.vicinityKey)
        aCoder.encode(formattedAddress, forKey: PropertyKey.formattedAddressKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: PropertyKey.idKey) as! String
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let placeId = aDecoder.decodeObject(forKey: PropertyKey.placeKey) as! String
        let icon = aDecoder.decodeObject(forKey: PropertyKey.iconKey) as! String
        let rating = aDecoder.decodeObject(forKey: PropertyKey.ratingKey) as! Double
        let photoReference = aDecoder.decodeObject(forKey: PropertyKey.photoReferenceKey) as! String
        let maxWidth = aDecoder.decodeObject(forKey: PropertyKey.maxWidthKey) as! Int
        let types = aDecoder.decodeObject(forKey: PropertyKey.typesKey) as! Array<String>
        let vicinity = aDecoder.decodeObject(forKey: PropertyKey.vicinityKey) as! String
        let formattedAddress = aDecoder.decodeObject(forKey: PropertyKey.formattedAddressKey) as! String
        self.init(id: id, name: name, placeId: placeId, rating: rating, icon: icon, photoReference: photoReference, maxWidth: maxWidth, types: types, vicinity: vicinity, formattedAddress: formattedAddress)
    }
    
}

