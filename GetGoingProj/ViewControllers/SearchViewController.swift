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
    
    // MARK: - View Controller Life Cycle Views
    override func viewDidLoad() {
        super.viewDidLoad()

    // Look for the defined delegate and perform action
       searchParametersTextField.delegate = self
    }
    
    // MARK: - Button Actions
    @IBAction func searchBtnAction(_ sender: UIButton) {
        
        print("starting search")
        searchParametersTextField.resignFirstResponder()
        
        if let inputValue = searchParam {
//            print("success")
            displayAlert(title: "Success!", message: "We got \(inputValue)")
            GooglePlacesAPI.textSearch(query: inputValue, completionHandler: {(status, json) in
                if let jsonObj = json {
                    let places = APIParser.parseAPIResponse(json: jsonObj)
                    // update UI on the main thread
                    DispatchQueue.main.async {
                        if places.count > 0 {
                            self.presentSearchResults(places)
                        } else {
                            self.displayAlert(title: "Oops", message: "There are no results")
                        }
                    }
                    print("\(places.count)")
                }
                else {
                    self.displayAlert(title: "Oops", message: "An error parsing json!")
                }
            })
        } else {
            displayAlert(title: "Oops!", message: "An error has occurred!")
        }
    }
    
    @IBAction func searchSelectionChanged(_ sender: UISegmentedControl) {
        print("segment control changed \(segmentedControl.selectedSegmentIndex)")
        if segmentedControl.selectedSegmentIndex == 1 {
            LocationService.sharedInstance.delegate = self
            LocationService.sharedInstance.startUpdatingLocation()
        }
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
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: {
            self.searchParametersTextField.placeholder = "Input something"
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
