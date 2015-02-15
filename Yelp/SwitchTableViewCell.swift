//
//  SwitchTableViewCell.swift
//  
//
//  Created by Ryan Newton on 2/12/15.
//
//

import UIKit

protocol SwitchCellDelegate {
    func didUpdateValue(cell: SwitchTableViewCell,value: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var switchItem: UISwitch!
    @IBOutlet weak var filterName: UILabel!
    
    var paramType: String?
    var paramValue: String?
    
    // why cant this be weak?
    var delegate: SwitchCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchValueChanged(sender: AnyObject) {
        self.delegate?.didUpdateValue(self, value: self.switchItem.on)
        
    }
}
