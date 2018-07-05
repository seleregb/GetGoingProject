//
//  SearchViewController.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-13.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchParametersTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var searchParam : String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterButton: UIButton!
    var filtersObject: [String: Any] = [:]
    
    
    // MARK: - View Controller Life Cycle Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Look for the defined delegate and perform action
        searchParametersTextField.delegate = self
        activityIndicator.isHidden = true
    }
    
    // MARK: - Button Actions
    @IBAction func searchBtnAction(_ sender: UIButton) {
        
        print("starting search")
        searchParametersTextField.resignFirstResponder()
        
        let isOpen = filtersObject["switchIsOn"] as? Bool
        let isSelected = filtersObject["rankSelected"] as? String
        let radiusSelected = filtersObject["radius"] as? Int
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if let inputValue = searchParam {
                GooglePlacesAPI.textSearch(query: inputValue, radius: radiusSelected!, openNow: isOpen, rankBy: isSelected, completionHandler: {(status, json) in
                    if let jsonObj = json {
                        let places = APIParser.parseAPIResponse(json: jsonObj)
                        //update UI on the main thread!
                        DispatchQueue.main.async {
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            if places.count > 0 {
                                self.presentSearchResults(places)
                                self.savePlacesToLocalStorage(places: places)
                            } else {
                                self.displayAlert(title: "Oops", message: "No results found")
                            }
                        }
                        print("\(places.count)")
                    } else {
                        self.displayAlert(title: "Oops", message: "An error parsing json")
                    }
                })
                
            } else {
                displayAlert(title: "Oops", message: "An error has occurred")
            }
        case 1:
            if let currentLocation = LocationService.sharedInstance.currentLocation {
                GooglePlacesAPI.nearbyLocationSearch(keyword: searchParam, locationCoordinates: currentLocation.coordinate, radius: radiusSelected!, openNow: isOpen, rankBy: isSelected, completionHandler: {(status, json) in
                    if let jsonObj = json {
                        let places = APIParser.parseAPIResponse(json: jsonObj)
                        //update UI on the main thread!
                        DispatchQueue.main.async {
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            if places.count > 0 {
                                self.presentSearchResults(places)
                                self.savePlacesToLocalStorage(places: places)
                            } else {
                                self.displayAlert(title: "Oops", message: "No results found")
                            }
                        }
                        print("\(places.count)")
                    } else {
                        self.displayAlert(title: "Oops", message: "An error parsing json")
                    }
                })
            } else {
                displayAlert(title: "Oops", message: "Could not identify your location")
            }
        default:
            break;
        }
        
    }
    
    @IBAction func searchSelectionChanged(_ sender: UISegmentedControl) {
        print("segment control changed \(segmentedControl.selectedSegmentIndex)")
        if segmentedControl.selectedSegmentIndex == 1 {
            LocationService.sharedInstance.delegate = self
            LocationService.sharedInstance.startUpdatingLocation()
        }
    }
    
    @IBAction func loadLastSavedResults(_ sender: UIButton) {
        if let places = loadListsFromLocalStorage() {
            presentSearchResults(places)
        }
    }
    
    // MARK: Local Storage
    func savePlacesToLocalStorage(places: [PlaceOfInterest]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(places, toFile: Constants.ArchiveURL.path)
        
        print("is sucessful save \(isSuccessfulSave)")
    }
    
    func loadListsFromLocalStorage() -> [PlaceOfInterest]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Constants.ArchiveURL.path) as? [PlaceOfInterest]
    }
    
    func presentSearchResults(_ results: [PlaceOfInterest]) {
        
        /* on calling this function instantiate the searchResultsViewController
         * pass to a variable, and cast it as type of SearchViewController
         * pass the results array as the places array
         * and navigate to the searchResultsViewController
         */
        let searchResultsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        
        searchResultsViewController.places = results
        
        navigationController?.pushViewController(searchResultsViewController, animated: true)
    }
    
    func displayAlert(title: String,message: String?) {
        displayAlertView(title: title, message: message)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filterViewController: FiltersViewController = segue.destination as! FiltersViewController
//        filtersObject = filterViewController.filtersObject
        filterViewController.delegate = self
    }
    
    
    @IBAction func presentFilters(_ sender: UIButton) {
        let filtersViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        
        present(filtersViewController, animated: true, completion: nil)
    }
    
}


// MARK: - Text Field Delegate
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchParametersTextField {
            textField.resignFirstResponder()
            return true
        }
        
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == searchParametersTextField {
            searchParam = textField.text
            print(searchParam ?? "no input")
        }
        
        return true
    }
}

// MARK: - Location Service Delegate

extension SearchViewController: LocationServiceDelegate {
    func tracingLocation(_ currentLocation: CLLocation) {
        print("\(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude) ")
    }
    
    func tracingLocationDidFailWithError(_ error: Error) {
        
    }
    
}

extension SearchViewController: FiltersServiceDelegate {
    func retrieveFilterParameters(controller: FiltersViewController, filters: [String : Any]) {
        controller.dismiss(animated: true, completion: nil)
        if filters.count > 0 {
            self.filtersObject = filters
            print("retrieved filters!")
        } else {
            print("filters not retrieved")
        }
    }
}
