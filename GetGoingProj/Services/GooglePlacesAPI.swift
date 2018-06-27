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
    
    class func textSearch(query: String, completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.textPlaceSearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
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
    
    class func nearbyLocationSearch(query: String?, locationCoordinates: CLLocationCoordinate2D, radius: Int = 5000 , completionHandler: @escaping(_ statusCode: Int, _ json: [String: Any]?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.nearbyPlaceSearch
        
        let location = "\(locationCoordinates.latitude),\(locationCoordinates.longitude)"
    
        urlComponents.queryItems = [
            URLQueryItem(name: "keyword", value: query),
            URLQueryItem(name: "location", value: location),
            URLQueryItem(name: "radius", value: String(radius)),
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
