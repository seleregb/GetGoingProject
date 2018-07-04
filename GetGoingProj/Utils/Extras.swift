//
//  Extras.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-29.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayAlertView(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
