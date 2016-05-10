//
//  AddEventViewController.swift
//  ClubManagement
//
//  Created by student5306 on 20/04/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate {
    
    private let REPETITION_WEEK = 1
    private let REPETITION_MONTH = 2
    private let TYPE_TRAINING = 0
    private let TYPE_COMPETITION = 1
    private let TYPE_STAGE = 2
    private let TYPE_OTHER = 3

    @IBOutlet weak var datePickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var beginningButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var repetition: UISegmentedControl!
    
    var delegate:AddEventProtocol!
    var baseDate:NSDate = NSDate()
    var dateExpanded = false
    var selectedButton:UIButton?
    var beginning:NSDate?
    var end:NSDate?
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        nameLabel.delegate = self
        doneButton.enabled = false
        
        dateFormatter.dateFormat = "dd/MM/yyyy' 'HH:mm"
        
        beginningButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        beginningButton.layer.cornerRadius = 5.0
        beginningButton.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor
        beginningButton.layer.borderWidth = 2.0
        beginning = NSDate()
        beginningButton.setTitle(dateFormatter.stringFromDate(beginning!), forState: .Normal)
        
        endButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        endButton.layer.cornerRadius = 5.0
        endButton.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor
        endButton.layer.borderWidth = 2.0
        end = NSDate()
        endButton.setTitle(dateFormatter.stringFromDate(end!), forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Textfield delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count > 0 {
            doneButton.enabled = true
        } else {
            doneButton.enabled = false
        }
        return true
    }
    
    //MARK: - Button actions
    
    @IBAction func cancel(sender: AnyObject) {
        delegate.addEvent([Event]())
    }
    
    @IBAction func addEvent(sender: AnyObject) {
        if let beginningDate = beginning, endDate = end {
            
            var eventType = EventType.Other
            switch type.selectedSegmentIndex {
            case TYPE_TRAINING:
                eventType = EventType.Training
                break
            case TYPE_COMPETITION:
                eventType = EventType.Competition
                break
            case TYPE_STAGE:
                eventType = EventType.Stage
                break
            default:
                break
            }
            
            var events = [Event]()
            let event = DBManager.sharedInstance.addEvent(nameLabel.text!, beginning: beginningDate, end: endDate, type: eventType, participants: nil)
            events.append(event)
            
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            
            switch repetition.selectedSegmentIndex {
            case REPETITION_WEEK:
                for week in 1...52 {
                    let eventForWeek = DBManager.sharedInstance.addEvent(nameLabel.text!, beginning: calendar.dateByAddingUnit(.WeekOfYear, value: week, toDate: beginningDate, options: NSCalendarOptions.MatchStrictly)!, end: calendar.dateByAddingUnit(.WeekOfYear, value: week, toDate: endDate, options: NSCalendarOptions.MatchStrictly)!, type: eventType, participants: nil)
                    events.append(eventForWeek)
                }
                break
            case REPETITION_MONTH:
                for month in 1...52 {
                    let eventForWeek = DBManager.sharedInstance.addEvent(nameLabel.text!, beginning: calendar.dateByAddingUnit(.Month, value: month, toDate: beginningDate, options: NSCalendarOptions.MatchStrictly)!, end: calendar.dateByAddingUnit(.Month, value: month, toDate: endDate, options: NSCalendarOptions.MatchStrictly)!, type: eventType ,participants: nil)
                    events.append(eventForWeek)
                }
                break
            default:
                break
            }
            
            delegate.addEvent(events)
        }
    }
    
    @IBAction func datePickerClick(sender: UIButton) {
        dismissKeyboard()
        datePickerViewHeight = changeConstant(datePickerViewHeight, constant: 216)
        UIView.animateWithDuration(0.5, animations: {
            self.formView.layoutIfNeeded()
            self.datePickerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
        selectedButton = sender
        
        if(sender == beginningButton) {
            if let date = beginning {
                datePicker.setDate(date, animated: true)
            }
        } else {
            if let date = end {
                datePicker.setDate(date, animated: true)
            }
        }
        
        dateExpanded = true
        endButton.enabled = false
        beginningButton.enabled = false
    }
    
    //MARK: - Expendable datepicker
    
    func changeConstant(constraint: NSLayoutConstraint, constant: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: constraint.multiplier,
            constant: constant)
        
        newConstraint.priority = constraint.priority
        
        NSLayoutConstraint.deactivateConstraints([constraint])
        NSLayoutConstraint.activateConstraints([newConstraint])
        
        return newConstraint
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if dateExpanded {
            for touch in touches {
                if touch.preciseLocationInView(self.view).y < formView.frame.height {
                    datePickerViewHeight = changeConstant(datePickerViewHeight, constant: 0)
                    UIView.animateWithDuration(0.5, animations: {
                        self.formView.layoutIfNeeded()
                        self.datePickerView.layoutIfNeeded()
                        self.view.layoutIfNeeded()
                    })
                    dateExpanded = false
                    endButton.enabled = true
                    beginningButton.enabled = true
                    
                    if selectedButton == beginningButton {
                        beginning = datePicker.date
                    } else {
                        end = datePicker.date
                    }
                    
                    if let button = selectedButton {
                        button.setTitle(dateFormatter.stringFromDate(datePicker.date), forState: .Normal)
                    }
                }
            }
        }
    }
    
}
