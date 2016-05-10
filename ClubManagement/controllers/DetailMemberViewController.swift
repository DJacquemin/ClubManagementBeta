//
//  DetailMemberViewController.swift
//  ClubManagement
//
//  Created by student5306 on 9/02/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

class DetailMemberViewController: UIViewController {
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var licenceExpirationButton: UIButton!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let editMemberIdentifier: String = "editMemberIdentifier"
    
    var member: Member!
    var dateExpanded = false
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        if let expirationDate = member.licenseExpiration {
            licenceExpirationButton.setTitle(dateFormatter.stringFromDate(expirationDate), forState: .Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        lastNameLabel.text = member.lastname
        firstNameLabel.text = member.firstname
        birthDateLabel.text = "date de naissance : " + dateFormatter.stringFromDate(member.birthdate!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case editMemberIdentifier:
                let editMemberViewController = segue.destinationViewController as! EditMemberViewController
                editMemberViewController.member = member
                break
            default:
                break
            }
        }
    }
    
    //MARK: - Change license expiration
    
    @IBAction func changeExpirationDate(sender: AnyObject) {
        dismissKeyboard()
        datePickerHeightConstraint = changeConstant(datePickerHeightConstraint, constant: 216)
        UIView.animateWithDuration(0.5, animations: {
            self.datePickerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
        
        dateExpanded = true
        licenceExpirationButton.enabled = false
    }
    
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
                if touch.preciseLocationInView(self.view).y < self.view.frame.height {
                    datePickerHeightConstraint = changeConstant(datePickerHeightConstraint, constant: 0)
                    UIView.animateWithDuration(0.5, animations: {
                        self.datePickerView.layoutIfNeeded()
                        self.view.layoutIfNeeded()
                    })
                    dateExpanded = false
                    licenceExpirationButton.enabled = true
                    
                    licenceExpirationButton.setTitle(dateFormatter.stringFromDate(datePicker.date), forState: .Normal)
                    member.licenseExpiration = datePicker.date
                }
            }
        }
    }
    
}
