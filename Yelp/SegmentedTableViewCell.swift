//
//  SegmentedTableViewCell.swift
//  Yelp
//
//  Created by Ryan Newton on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol SegmentedCellDelegate {
    func newSegmentSelected(cell: SegmentedTableViewCell)
}


class SegmentedTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var delegate: SegmentedCellDelegate?
    var paramType: NSString?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillWithOptions(options: NSArray) {
        var ind = 0
        segmentedControl.removeAllSegments()
        for title in options {
            segmentedControl.insertSegmentWithTitle(title as String, atIndex: ind, animated: false)
            ind += 1
        }
    }
    
    @IBAction func newSegmentSelected(sender: UISegmentedControl) {
        self.delegate!.newSegmentSelected(self)
    }
}
