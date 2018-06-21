//
//  DetailsViewController.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-20.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

    var place: PlaceOfInterest!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
