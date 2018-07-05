//
//  FiltersService.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-07-05.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import Foundation
import UIKit

protocol FiltersServiceDelegate {
    func retrieveFilterParameters(controller: FiltersViewController, filters: [String: Any])
}
