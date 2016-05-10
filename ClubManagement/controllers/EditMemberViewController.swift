//
//  EditMemberViewController.swift
//  ClubManagement
//
//  Created by student5306 on 9/02/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

class EditMemberViewController: UIViewController {
    
    @IBOutlet weak var lastNameTextEdit: UITextField!
    @IBOutlet weak var firstNameTextEdit: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var birthdatePicker: UIButton!
    @IBOutlet weak var birthDatePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePickerView: UIView!
    
    var member:Member!
    var dateExpanded = false
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        birthdatePicker.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        birthdatePicker.layer.cornerRadius = 5.0
        birthdatePicker.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor
        birthdatePicker.layer.borderWidth = 2.0
        
        birthdatePicker.setTitle(dateFormatter.stringFromDate(member.birthdate!), forState: .Normal)
        birthDatePicker.setDate(member.birthdate!, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        lastNameTextEdit.text = member.lastname
        firstNameTextEdit.text = member.firstname
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Buttons
    
    @IBAction func cancelButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    @IBAction func editMemberAction(sender: AnyObject) {
        
        if(self.lastNameTextEdit.text != ""){
            self.member.lastname = self.lastNameTextEdit.text
        }
        if(self.lastNameTextEdit.text != ""){
            self.member.firstname = self.firstNameTextEdit.text
        }
        self.member.birthdate = self.birthDatePicker.date
        
        dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    //MARK: - Datepicker
    
    @IBAction func chooseDate(sender: AnyObject) {
        dismissKeyboard()
        birthDatePickerHeightConstraint = changeConstant(birthDatePickerHeightConstraint, constant: 216)
        UIView.animateWithDuration(0.5, animations: {
            self.datePickerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
        
        dateExpanded = true
        birthdatePicker.enabled = false
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
                    birthDatePickerHeightConstraint = changeConstant(birthDatePickerHeightConstraint, constant: 0)
                    UIView.animateWithDuration(0.5, animations: {
                        self.datePickerView.layoutIfNeeded()
                        self.view.layoutIfNeeded()
                    })
                    dateExpanded = false
                    birthDatePicker.enabled = true
                    
                    birthdatePicker.setTitle(dateFormatter.stringFromDate(birthDatePicker.date), forState: .Normal)
                }
            }
        }
    }
    
}
