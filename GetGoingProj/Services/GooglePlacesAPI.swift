//
//  GooglePlacesAPI.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-18.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation
import CoreLocation

class GooglePlacesAPI {
    
    class func textSearch(query: String, radius: Int = 5000, openNow: Bool?, rankBy: String?, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.textPlaceSearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        if let openNow = openNow {
            urlComponents.queryItems?.append(URLQueryItem(name: "opennow", value: String(openNow)))
        }
        
        if radius == 5000 {
            urlComponents.queryItems?.append(URLQueryItem(name: "radius", value: String(radius)))
        } else {
            urlComponents.queryItems?.append(URLQueryItem(name: "rankby", value: rankBy))
        }
        
        retrieveJsonResponseFromUrl(urlComponents: urlComponents, callbackFunction: completionHandler)
    }
    
    class func placeDetailsSearch(query: String, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.placeDetails
        
        urlComponents.queryItems = [
            URLQueryItem(name: "placeid", value: query),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        retrieveJsonResponseFromUrl(urlComponents: urlComponents, callbackFunction: completionHandler)
    }
    
    class func nearbyLocationSearch(keyword: String?, locationCoordinates: CLLocationCoordinate2D, radius: Int = 5000 , openNow: Bool?, rankBy: String?, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.nearbyPlaceSearch
        
        let location = "\(locationCoordinates.latitude),\(locationCoordinates.longitude)"
    
        urlComponents.queryItems = [
            URLQueryItem(name: "location", value: location),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        if let keyword = keyword, let openNow = openNow {
            urlComponents.queryItems?.append(URLQueryItem(name: "keyword", value: keyword))
            urlComponents.queryItems?.append(URLQueryItem(name: "opennow", value: String(openNow)))
        }
        
        if radius == 5000 {
            urlComponents.queryItems?.append(URLQueryItem(name: "radius", value: String(radius)))
        } else {
            urlComponents.queryItems?.append(URLQueryItem(name: "rankby", value: rankBy))
        }
    
        retrieveJsonResponseFromUrl(urlComponents: urlComponents, callbackFunction: completionHandler)
    }
    
    class func placePhotoSearch(maxWidth: Double, photoReference: String, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.placePhotoSearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "photoreference", value: photoReference),
            URLQueryItem(name: "maxwidth", value: String(maxWidth)),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        retrieveJsonResponseFromUrl(urlComponents: urlComponents, callbackFunction: completionHandler)
    }
    
    class func retrieveJsonResponseFromUrl(urlComponents: URLComponents, callbackFunction: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void) {
        NetworkingLayer.getRequest(with: urlComponents) {
            (statusCode, data) in
            if let jsonData = data, let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                print(jsonObject ?? "")
                callbackFunction(statusCode, jsonObject)
            } else {
                print("This is not easy")
                callbackFunction(statusCode, nil)
            }
        }
    }
}
