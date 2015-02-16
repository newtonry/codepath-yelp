//
//  CheckboxTableViewCell.swift
//  Yelp
//
//  Created by Ryan Newton on 2/13/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class CheckboxTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!

    var canonicalName: String? // This seems like a pretty crappy way of doing it
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
