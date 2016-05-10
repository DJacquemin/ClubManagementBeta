//
//  EventTableViewCell.swift
//  ClubManagement
//
//  Created by student5306 on 22/04/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var beginningLabel: UILabel!
    
    let formatter = NSDateFormatter()
    
    var event:Event! {
        didSet {
            formatter.dateFormat = "HH:mm"
            nameLabel.text = event.name!
            beginningLabel.text = formatter.stringFromDate(event.beginning!)
            endLabel.text = formatter.stringFromDate(event.end!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
