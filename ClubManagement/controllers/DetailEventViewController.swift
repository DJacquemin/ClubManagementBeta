//
//  DetailEventViewController.swift
//  ClubManagement
//
//  Created by student5306 on 22/04/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

class DetailEventViewController: UIViewController, UITableViewDataSource, AddParticipantProtocol {
    
    private let PARTICIPANT_CELL_IDENTIFIER = "participantCellIdentifier"
    private let ADD_MEMBER_SEGUE_IDENTIFIER = "addParticipantSegueIdentifier"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var beginningLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var participantList: UITableView!
    
    var event:Event! {
        didSet {
            participants = event.participants!.allObjects as! [Member]
        }
    }
    var participants:[Member]!
    let formatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "dd/MM/yyyy - HH:mm"
        
        participantList.dataSource = self

        titleLabel.text = event.name!
        beginningLabel.text = "début : \(formatter.stringFromDate(event.beginning!))"
        endLabel.text = "fin : \(formatter.stringFromDate(event.end!))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case ADD_MEMBER_SEGUE_IDENTIFIER:
                let controller = segue.destinationViewController as! AddParticipantViewController
                controller.event = event
                controller.delegate = self
                break
            default:
                break
            }
        }
    }
    
    //MARK: - Tableview delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = participantList.dequeueReusableCellWithIdentifier(PARTICIPANT_CELL_IDENTIFIER, forIndexPath: indexPath)
        
        cell.textLabel?.text = participants[indexPath.row].firstname
        cell.detailTextLabel?.text = participants[indexPath.row].lastname
        
        return cell
    }
    
    //MARK: - AddParticipantProtocol
    
    func addParticipant() {
        dismissViewControllerAnimated(true, completion: nil)
        participants = event.participants!.allObjects as! [Member]
        participantList.reloadData()
    }
    
}
