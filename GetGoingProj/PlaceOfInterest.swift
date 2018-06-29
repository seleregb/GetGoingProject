//
//  PlaceOfInterest.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-18.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation
import CoreLocation

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
    }
    
    var id: String
    var name: String
    var rating: Double?
    var formattedAddress: String?
    var iconImageView: String?
    var placeId: String?
    var website: String?
    var formattedPhoneNumber: String?
    var location: CLLocation?
    var photoReference: String?
    var types: Array<String>?
    var vicinity: String?
    var maxWidth: Double?
    var photos: Array<[String: Any]>?
    
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
        
        self.photos = json["photos"] as? Array<[String: Any]>
        
        if let photo = json["photos"] as? Array<[String: Any]> {
            if !photo.isEmpty {
                self.photoReference = photo.first!["photo_reference"] as? String
                self.maxWidth = photo.first!["width"] as? Double
            }
        }
        
        self.types = json["types"] as? Array<String>
        self.vicinity = json["vicinity"] as? String
        
    }
    
    init(id: String, name: String, rating: Double, icon: String, photoReference: String, maxWidth: Double, types: Array<String>, vicinity: String, formattedAddress: String) {
        self.id = id
        self.name = name
        self.rating = rating
        self.iconImageView = icon
        self.photoReference = photoReference
        self.maxWidth = maxWidth
        self.types = types
        self.vicinity = vicinity
        self.formattedAddress = formattedAddress
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.idKey)
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(rating, forKey: PropertyKey.ratingKey)
        aCoder.encode(iconImageView, forKey: PropertyKey.iconKey)
        aCoder.encode(photoReference, forKey: PropertyKey.photoReferenceKey)
        aCoder.encode(maxWidth, forKey: PropertyKey.maxWidthKey)
        aCoder.encode(types, forKey: PropertyKey.typesKey)
        aCoder.encode(vicinity, forKey: PropertyKey.vicinityKey)
        aCoder.encode(formattedAddress, forKey: PropertyKey.formattedAddressKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: PropertyKey.idKey) as! String
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let icon = aDecoder.decodeObject(forKey: PropertyKey.iconKey) as! String
        let rating = aDecoder.decodeObject(forKey: PropertyKey.ratingKey) as! Double
        let photoReference = aDecoder.decodeObject(forKey: PropertyKey.photoReferenceKey) as! String
        let maxWidth = aDecoder.decodeObject(forKey: PropertyKey.maxWidthKey) as! Double
        let types = aDecoder.decodeObject(forKey: PropertyKey.typesKey) as! Array<String>
        let vicinity = aDecoder.decodeObject(forKey: PropertyKey.vicinityKey) as! String
        let formattedAddress = aDecoder.decodeObject(forKey: PropertyKey.formattedAddressKey) as! String
        self.init(id: id, name: name, rating: rating, icon: icon, photoReference: photoReference, maxWidth: maxWidth, types: types, vicinity: vicinity, formattedAddress: formattedAddress)
    }
    
}

