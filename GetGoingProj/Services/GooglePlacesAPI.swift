//
//  GooglePlacesAPI.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-18.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation

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
        
        NetworkingLayer.getRequest(with: urlComponents) {
            (statusCode, data) in
            if let jsonData = data, let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                print(jsonObject ?? "")
                completionHandler(statusCode, jsonObject)
            } else {
                print("This is not easy")
                completionHandler(statusCode, nil)
            }
        }
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
        
        NetworkingLayer.getRequest(with: urlComponents) {
            (statusCode, data) in
            if let jsonData = data, let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                print(jsonObject ?? "")
                completionHandler(statusCode, jsonObject)
            } else {
                print("This is not easy")
                completionHandler(statusCode, nil)
            }
        }
    }
}
