//
//  NewsViewController.swift
//  ClubManagement
//
//  Created by student5306 on 9/02/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource {
    
    private let CUSTOM_CELL_IDENTIFIER = "customCellIdentifier"
    private let CUSTOM_CELL_IDENTIFIER_2 = "customCellIdentifier2"
    
    @IBOutlet weak var licenseTableView: UITableView!
    @IBOutlet weak var eventTableView: UITableView!
    
    lazy var licenses = DBManager.sharedInstance.getMemberWithLicenceExpiration()
    lazy var events = DBManager.sharedInstance.getNextEvents()
    
    let formatter = NSDateFormatter()
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    var oneMonthEarlier:NSDate?
    var twoMonthEarlier:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "dd/MM/yyyy"
        oneMonthEarlier = calendar?.dateByAddingUnit(.Month, value: -1, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)
        twoMonthEarlier = calendar?.dateByAddingUnit(.Month, value: -2, toDate: NSDate(), options: NSCalendarOptions.MatchStrictly)

        licenseTableView.dataSource = self
        eventTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == licenseTableView {
            if let licensesCount =  licenses {
                return licensesCount.count
            }
        } else {
            if let eventsCount = events {
                return eventsCount.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell!
        
        if tableView == licenseTableView {
            cell = licenseTableView.dequeueReusableCellWithIdentifier(CUSTOM_CELL_IDENTIFIER, forIndexPath: indexPath) as! CustomTableViewCell
            cell.mainLabel.text = licenses![indexPath.row].firstname! + " " + licenses![indexPath.row].lastname!
            cell.detailLabel.text = "expiration : " + formatter.stringFromDate(licenses![indexPath.row].licenseExpiration!)
            if licenses![indexPath.row].licenseExpiration!.compare(oneMonthEarlier!) == NSComparisonResult.OrderedDescending {
                cell.colorImageView.backgroundColor = UIColor.redColor()
            } else if licenses![indexPath.row].licenseExpiration!.compare(twoMonthEarlier!) == NSComparisonResult.OrderedDescending {
                cell.colorImageView.backgroundColor = UIColor.orangeColor()
            } else {
                cell.colorImageView.backgroundColor = UIColor.yellowColor()
            }
        } else {
            cell = eventTableView.dequeueReusableCellWithIdentifier(CUSTOM_CELL_IDENTIFIER_2, forIndexPath: indexPath) as! CustomTableViewCell
            cell.mainLabel.text = events![indexPath.row].name
            cell.detailLabel.text = formatter.stringFromDate(events![indexPath.row].beginning!)
            switch(events![indexPath.row].type!) {
            case EventType.Training.rawValue:
                cell.colorImageView.backgroundColor = UIColor(red: 28/255, green: 209/255, blue: 33/255, alpha: 1)
                break
            case EventType.Competition.rawValue:
                cell.colorImageView.backgroundColor = UIColor(red: 247/255, green: 77/255, blue: 31/255, alpha: 1)
                break
            case EventType.Stage.rawValue:
                cell.colorImageView.backgroundColor = UIColor(red: 73/255, green: 126/255, blue: 243/255, alpha: 1)
                break
            default:
                cell.colorImageView.backgroundColor = UIColor(red: 166/255, green: 88/255, blue: 242/255, alpha: 1)
                break
            }
        }
        
        return cell
    }

}
