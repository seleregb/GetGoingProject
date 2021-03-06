//
//  POITableViewCell.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-20.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import UIKit

class POITableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var categoryTypesLabel: UILabel!
    
    override func prepareForReuse() {
//        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
