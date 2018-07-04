//
//  SearchResultsViewController.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-18.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var places: [PlaceOfInterest]!
    var placeParam: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Sorting data based on the selected segmented control
    @IBAction func sortSelectionChanged(_ sender: UISegmentedControl) {
        
        let selectedSegment = segmentedControl.selectedSegmentIndex
        print("selected sort segment: \(selectedSegment)")
        if selectedSegment == 0 {
            let sortedPlacesArray = places.sorted {
                $0.name > $1.name
            }
            places = sortedPlacesArray
            print("sorted places by name!")
        }
        else {
            let sortedPlacesArray = places.sorted {
                $0.rating! > $1.rating!
            }
            places = sortedPlacesArray
            print("sorted places by rating!")
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tableViewCellNib = UINib(nibName: "POITableViewCell", bundle: nil)
        tableView.register(tableViewCellNib, forCellReuseIdentifier: "reusableIdentifier")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - TableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableIdentifier") as! POITableViewCell
        
        cell.titleLabel.text = places[indexPath.row].name
        cell.addressLabel.text = places[indexPath.row].formattedAddress
        
        if let imageUrl = places[indexPath.row].iconUrl, let url = URL(string: imageUrl), let dataContents = try? Data(contentsOf: url), let imageSrc = UIImage(data: dataContents) {
            cell.iconImageView.image = imageSrc
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPlace = places[indexPath.row]
        if let placeId = selectedPlace.placeId {
            GooglePlacesAPI.placeDetailsSearch(query: placeId, completionHandler: {(status, json) in
                if let jsonObj = json {
                    let place = APIParser.parseAPIResponseForPlaceDetails(json: jsonObj)
                    print("found place \(place)")
                    DispatchQueue.main.async {
                        self.presentPlaceDetails(place)
                    }
                }
                else {
                    print("error parsing json!")
                }
            })
        }
    }
    
    func presentPlaceDetails(_ results: PlaceOfInterest) {
        let detailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        detailsViewController.place = results
        
        navigationController?.pushViewController(detailsViewController, animated: true)
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
