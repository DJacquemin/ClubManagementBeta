//
//  ViewController.swift
//  ClubManagement
//
//  Created by student5306 on 8/02/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

protocol AddMemberProtocol: NSObjectProtocol
{
    func addMember(member:Member);
}

class MemberListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddMemberProtocol {
    
    private let addMemberIdentifier = "addMemberIdentifier"
    private let detailMemberIdentifier = "detailMemberIdentifier"
    private let cellMemberIdentifier = "cellMemberIdentifier"
    private let headerIdentifier = "headerIdentifier"
    
    @IBOutlet weak var membersTableView: UITableView!
    
    private var members:Members!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        members = Members()
    }
    
    override func viewWillAppear(animated: Bool) {
        membersTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case detailMemberIdentifier:
                if let indexPath = membersTableView.indexPathForSelectedRow {
                    let member = members.getMember(indexPath.section, row: indexPath.row)
                    let detailMemberViewController = segue.destinationViewController as! DetailMemberViewController
                    detailMemberViewController.member = member
                    membersTableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
                break
            case addMemberIdentifier:
                let addMemberController = segue.destinationViewController as! AddMemberViewController
                addMemberController.delegate = self
                break
            default:
                break
            }
        }
        
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members[members.firstLetters[section]].count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        DBManager.sharedInstance.removeMember(members[indexPath.section, indexPath.row])
        membersTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellMemberIdentifier, forIndexPath: indexPath)
        
        let member = members[indexPath.section, indexPath.row]
        
        cell.textLabel?.text = member.lastname
        cell.detailTextLabel?.text = member.firstname
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(headerIdentifier)
        
        cell?.textLabel?.text = members.firstLetters[section]
        cell!.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        
        return cell
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return members.firstLetters
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return members.firstLetters.count
    }
    
    // MARK: - AddMemberProtocol
    
    func addMember(member: Member) {
        dismissViewControllerAnimated(true) { () -> Void in
            self.members.addMember(member)
            self.membersTableView.reloadData()
        }
    }
    
}

