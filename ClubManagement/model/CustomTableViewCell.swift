//
//  CustomTableViewCell.swift
//  ClubManagement
//
//  Created by student5306 on 28/04/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var colorImageView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    let formatter = NSDateFormatter()
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
