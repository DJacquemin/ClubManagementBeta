//
//  AddParticipantViewController.swift
//  ClubManagement
//
//  Created by student5306 on 25/04/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

protocol AddParticipantProtocol {
    func addParticipant()
}

class AddParticipantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let ADD_PARTICIPANT_CELL_IDENTIFIER = "addParticipantCellIdentifier"
    
    @IBOutlet weak var participantTableView: UITableView!
    
    var delegate:AddParticipantProtocol!
    
    var event:Event! {
        didSet {
            participant = event.participants?.allObjects as! [Member]
        }
    }
    var participant:[Member]!
    var allMember:[Member]!

    override func viewDidLoad() {
        super.viewDidLoad()

        participantTableView.dataSource = self
        participantTableView.delegate = self
        
        allMember = DBManager.sharedInstance.allMember()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Navigationbar button actions
    
    @IBAction func done(sender: AnyObject) {
        delegate.addParticipant()
    }
    
    //MARK: - TableView delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMember.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = participantTableView.dequeueReusableCellWithIdentifier(ADD_PARTICIPANT_CELL_IDENTIFIER, forIndexPath: indexPath)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.textLabel?.text = allMember[indexPath.row].firstname
        cell.detailTextLabel?.text = allMember[indexPath.row].lastname
        
        if participant.contains(allMember[indexPath.row]) {
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = tableView.cellForRowAtIndexPath(indexPath)
        if participant.contains(allMember[indexPath.row]) {
            row?.backgroundColor = UIColor.clearColor()
            
            participant.removeAtIndex(participant.indexOf(allMember[indexPath.row])!)
            
            allMember[indexPath.row].removeEventsObject(event)
            event.removeParticipantsObject(allMember[indexPath.row])
        } else {
            row?.backgroundColor = UIColor.lightGrayColor()
            
            participant.append(allMember[indexPath.row])
            allMember[indexPath.row].addEventsObject(event)
            event.addParticipantsObject(allMember[indexPath.row])
        }
    }
    
}
