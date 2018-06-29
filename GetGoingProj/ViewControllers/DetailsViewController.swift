//
//  DetailsViewController.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-20.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailsViewController: UIViewController, MKMapViewDelegate {

    var place: PlaceOfInterest!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressLabel.text = place.formattedAddress
        websiteLabel.text = place.website
        phoneNumberLabel.text = place.formattedPhoneNumber
        setMapViewCoordinate()
        retievePlacePhoto(placeObj: place)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMapViewCoordinate(){
        
        mapView.delegate = self
        
        if let coordinate = place.location?.coordinate {
            //constructing the Annotation view (pin with the title) on the map
            let annotation = MKPointAnnotation()
            annotation.title = place?.name
            annotation.coordinate.latitude = coordinate.latitude
            annotation.coordinate.longitude =  coordinate.longitude
            mapView.addAnnotation(annotation)
            //centering map camera on the point
            centerMapOnLocation(annotation.coordinate)
            
            //indicator in blue of user's current location if allowed by the user.
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        let radius = 5000
        let region = MKCoordinateRegionMakeWithDistance(location, CLLocationDistance(Double(radius) * 2.0), CLLocationDistance(Double(radius) * 2.0))
        
        //set the camera on the mapview to cover 5000 radius aroung the point (like a zoom level)
        mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //if user's current location (blue dot), ignore
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        //otherwise, customizing pin on the map for a given l=point.
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "reusePin")
        //allowing to show extra information in the pin view
        view.canShowCallout = true
        //"i" button
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        view.pinTintColor = UIColor.blue
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //accessory (by default - "i" button on your annotation view.
        let location = view.annotation
        //preparation for a mode in Apple Maps
        let launchingOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        if let coordinate = view.annotation?.coordinate {
            //open apple maps with the required coordinate and launching options - walking mode
            location?.mapItem(coordinate:coordinate).openInMaps(launchOptions: launchingOptions)
        }
    }

    func retievePlacePhoto(placeObj: PlaceOfInterest) {
//        let selectedPlace = places[indexPath.row]
        GooglePlacesAPI.placePhotoSearch(maxWidth: place.maxWidth!, photoReference: place.photoReference!, completionHandler: {(status, json) in
                if let jsonObj = json {
                    let place = APIParser.parseAPIResponseForPlaceDetails(json: jsonObj)
                    print("found place \(place)")
                    if let imageUrl = placeObj.iconImageView, let url = URL(string: imageUrl), let dataContents = try? Data(contentsOf: url), let imageSrc = UIImage(data: dataContents) {
                        self.photoImageView.image = imageSrc
                    }
                }
                else {
                    print("error parsing json!")
                }
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

extension MKAnnotation {
    func mapItem(coordinate: CLLocationCoordinate2D) -> MKMapItem {
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        return mapItem
    }
}
