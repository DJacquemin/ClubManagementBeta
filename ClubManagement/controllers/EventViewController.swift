//
//  EventViewController.swift
//  ClubManagement
//
//  Created by student5306 on 20/04/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit
import FSCalendar
import NGSPopoverView

protocol AddEventProtocol: NSObjectProtocol
{
    func addEvent(events:[Event]);
}

class EventViewController: UIViewController, AddEventProtocol, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDataSource {

    private let ADD_EVENT_SEGUE_IDENTIFIER = "addEventSegueIdentifier"
    private let DETAIL_EVENT_SEGUE_IDENTIFIER = "detailEventSegueIdentifier"
    private let EVENT_CELL_IDENTIFIER = "eventCellIdentifier"
    
    let switch_0 = UISwitch()
    let switch_1 = UISwitch()
    let switch_2 = UISwitch()
    let switch_3 = UISwitch()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var eventsTableView: UITableView!
    
    lazy var events = [String: [Event]]()
    var eventsForTableview:[Event]! {
        didSet {
            eventsTableView.reloadData()
        }
    }
    let formatter = NSDateFormatter()
    
    var renderTraining = true
    var renderCompetition = true
    var renderStage = true
    var renderOther = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "MMM dd yyyy"
        
        switch_0.on = true
        switch_1.on = true
        switch_2.on = true
        switch_3.on = true
        
        calendar.delegate = self
        eventsTableView.dataSource = self
        
        loadEvents()
        calendar.reloadData()
        loadEventForTableView(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        eventsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadEvents() {
        if let dbEvents = DBManager.sharedInstance.allEvents() {
            for event in dbEvents {
                let date = formatter.stringFromDate(event.beginning!)
                if !events.keys.contains(date) {
                    events[date] = [Event]()
                }
                events[date]?.append(event)
            }
        }
    }
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case ADD_EVENT_SEGUE_IDENTIFIER:
                let controller = segue.destinationViewController as! AddEventViewController
                controller.delegate = self
                controller.baseDate = calendar.selectedDate
                break
            case DETAIL_EVENT_SEGUE_IDENTIFIER:
                let controller = segue.destinationViewController as! DetailEventViewController
                if let index = eventsTableView.indexPathForSelectedRow?.row {
                    controller.event = eventsForTableview[index]
                }
                break
            default:
                break
            }
        }
    }
    
    //MARK: - Events
    
    func addEvent(events: [Event]) {
        
        for event in events {
            let date = formatter.stringFromDate(event.beginning!)
            if !self.events.keys.contains(date) {
                self.events[date] = [Event]()
            }
            self.events[date]?.append(event)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        calendar.reloadData()
        eventsTableView.reloadData()
    }
    
    func loadEventForTableView(date:NSDate?) {
        if let dateOfEvent = date {
            let dateKey = formatter.stringFromDate(dateOfEvent)
            if events.keys.contains(dateKey) {
                eventsForTableview = events[dateKey]
            } else {
                eventsForTableview = [Event]()
            }
        } else {
            if let eventsTab = DBManager.sharedInstance.eventsForToday() {
                eventsForTableview = eventsTab
            }
        }
    }
    
    //MARK: - Detail event delegate
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
        eventsTableView.reloadData()
    }
    
    //MARK: - Calendar
    
    func calendar(calendar: FSCalendar, appearance: FSCalendarAppearance, fillColorForDate date: NSDate) -> UIColor? {
        let formattedDate = formatter.stringFromDate(date)
        if events.keys.contains(formattedDate) && events[formattedDate]?.count > 0 {
            
            if events[formattedDate]?.count > 1 {
                for eventIndex in 0..<(events[formattedDate]?.count)! - 1 {
                    if events[formattedDate]![eventIndex].type != events[formattedDate]![eventIndex + 1].type {
                        return UIColor(red: 245/255, green: 183/255, blue: 53/255, alpha: 1)
                    }
                }
                switch events[formattedDate]![0].type! {
                case EventType.Training.rawValue:
                    if renderTraining {
                        return UIColor(red: 28/255, green: 209/255, blue: 33/255, alpha: 1)
                    }
                case EventType.Competition.rawValue:
                    if renderCompetition {
                        return UIColor(red: 247/255, green: 77/255, blue: 31/255, alpha: 1)
                    }
                case EventType.Stage.rawValue:
                    if renderStage {
                        return UIColor(red: 73/255, green: 126/255, blue: 243/255, alpha: 1)
                    }
                default:
                    if renderOther {
                        return UIColor(red: 166/255, green: 88/255, blue: 242/255, alpha: 1)
                    }
                }
            } else if events[formattedDate]?.count > 0 {
                if let type = events[formattedDate]![0].type {
                    switch type {
                    case EventType.Training.rawValue:
                        if renderTraining {
                            return UIColor(red: 28/255, green: 209/255, blue: 33/255, alpha: 1)
                        }
                    case EventType.Competition.rawValue:
                        if renderCompetition {
                            return UIColor(red: 247/255, green: 77/255, blue: 31/255, alpha: 1)
                        }
                    case EventType.Stage.rawValue:
                        if renderStage {
                            return UIColor(red: 73/255, green: 126/255, blue: 243/255, alpha: 1)
                        }
                    default:
                        if renderOther {
                            return UIColor(red: 166/255, green: 88/255, blue: 242/255, alpha: 1)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        loadEventForTableView(date)
    }
    
    //MARK: - Tableview delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsForTableview.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCellWithIdentifier(EVENT_CELL_IDENTIFIER, forIndexPath: indexPath) as! EventTableViewCell
        
        cell.event = eventsForTableview[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let date = formatter.stringFromDate(eventsForTableview[indexPath.row].beginning!)
        DBManager.sharedInstance.removeEvent(eventsForTableview[indexPath.row])
        events[date]?.removeAtIndex(indexPath.row)
        eventsForTableview.removeAtIndex(indexPath.row)
        eventsTableView.reloadData()
        calendar.reloadData()
    }
    
    //MARK: - Popover
    
    @IBAction func showFilters(sender: UIBarButtonItem) {
        let stackview = UIStackView()
        stackview.axis = .Vertical
        stackview.spacing = 10.0
        
        let stackview_0 = UIStackView()
        let label_0 = UILabel()
        label_0.frame.size.width = 160
        label_0.text = "Entraînement"
        switch_0.addTarget(self, action: #selector(filterDate(_:)), forControlEvents: .ValueChanged)
        
        stackview_0.addArrangedSubview(label_0)
        stackview_0.addArrangedSubview(switch_0)
        stackview.addArrangedSubview(stackview_0)
        
        let stackview_1 = UIStackView()
        let label_1 = UILabel()
        label_1.frame.size.width = 160
        label_1.text = "Compétition"
        switch_1.addTarget(self, action: #selector(filterDate(_:)), forControlEvents: .ValueChanged)
        
        stackview_1.addArrangedSubview(label_1)
        stackview_1.addArrangedSubview(switch_1)
        stackview.addArrangedSubview(stackview_1)
        
        let stackview_2 = UIStackView()
        let label_2 = UILabel()
        label_2.frame.size.width = 160
        label_2.text = "Stage"
        switch_2.addTarget(self, action: #selector(filterDate(_:)), forControlEvents: .ValueChanged)
        
        stackview_2.addArrangedSubview(label_2)
        stackview_2.addArrangedSubview(switch_2)
        stackview.addArrangedSubview(stackview_2)
        
        let stackview_3 = UIStackView()
        let label_3 = UILabel()
        label_3.frame.size.width = 160
        label_3.text = "Autre"
        switch_3.addTarget(self, action: #selector(filterDate(_:)), forControlEvents: .ValueChanged)
        
        stackview_3.addArrangedSubview(label_3)
        stackview_3.addArrangedSubview(switch_3)
        stackview.addArrangedSubview(stackview_3)
        
        let popover = NGSPopoverView(cornerRadius: 10.0, direction: NGSPopoverArrowPosition.Automatic, arrowSize: CGSizeMake(20, 10))
        popover.contentView = stackview;
        popover.shouldMaskSourceViewToVisible = true;
        let view = sender.valueForKey("view") as! UIView
        popover.maskedSourceViewCornerRadius = view.frame.size.width/2
        
        popover.showFromView(view, animated: true)
    }
    
    //MARK: - Filter selector
    
    
    func filterDate(sender: UISwitch) {
        switch sender {
        case switch_0:
            renderTraining = sender.on
            break
        case switch_1:
            renderCompetition = sender.on
            break
        case switch_2:
            renderStage = sender.on
            break
        case switch_3:
            renderOther = sender.on
            break
        default:
            break
        }
        calendar.reloadData()
    }
    
}
