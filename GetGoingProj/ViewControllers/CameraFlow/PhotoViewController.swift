//
//  PhotoViewController.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-07-06.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var photo: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = photo
    }
    
    @IBAction func savePhoto(_ sender: UIButton) {
        if let photo = photo {
            UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil)
        }
    }
    
}
