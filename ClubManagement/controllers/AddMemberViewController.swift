//
//  AddMemberViewController.swift
//  ClubManagement
//
//  Created by student5306 on 8/02/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import UIKit

class AddMemberViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var birthdatePickerButton: UIButton!
    @IBOutlet weak var birthdatePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var birthdatePickerView: UIView!
    @IBOutlet weak var birthdatePicker: UIDatePicker!
    @IBOutlet weak var licenseExpirationButton: UIButton!
    
    weak var delegate: AddMemberProtocol!
    
    var dateExpanded = false
    var isBirthdateSelected = true
    var birthDate = NSDate()
    var licenseExpirationDate = NSDate()
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        addButton.enabled = false;
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        birthdatePickerButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        birthdatePickerButton.layer.cornerRadius = 5.0
        birthdatePickerButton.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor
        birthdatePickerButton.layer.borderWidth = 2.0
        
        licenseExpirationButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        licenseExpirationButton.layer.cornerRadius = 5.0
        licenseExpirationButton.layer.borderColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1).CGColor
        licenseExpirationButton.layer.borderWidth = 2.0
        
        birthdatePickerButton.setTitle(dateFormatter.stringFromDate(NSDate()), forState: .Normal)
        licenseExpirationButton.setTitle(dateFormatter.stringFromDate(NSDate()), forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMember(sender: AnyObject) {
        if let member = getMember()
        {
            delegate?.addMember(member)
        } else {
            addButton.tintColor = UIColor.grayColor()
            addButton.enabled = false
        }
    }
    
    @IBAction func returnButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func getMember() -> Member?
    {
        if let lastName = lastNameTextField.text, let firstName = firstNameTextField.text
            where lastName.characters.count > 0 && firstName.characters.count > 0{
                let member = DBManager.sharedInstance.addMember(lastName, firstname: firstName, birthdate: birthDate, licenseExpiration: licenseExpirationDate, events: nil)
            member.licenseExpiration = licenseExpirationDate
                return member
        }
        
        return .None
    }
    
    //MARK: - DatePicker
    
    @IBAction func chooseBirthdate(sender: AnyObject) {
        dismissKeyboard()
        birthdatePickerHeightConstraint = changeConstant(birthdatePickerHeightConstraint, constant: 216)
        UIView.animateWithDuration(0.5, animations: {
            self.birthdatePickerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
        
        dateExpanded = true
        birthdatePickerButton.enabled = false
        licenseExpirationButton.enabled = false
        
        birthdatePicker.setDate(birthDate, animated: false)
        isBirthdateSelected = true
    }
    
    @IBAction func selectedExpirationDate(sender: UIButton) {
        dismissKeyboard()
        birthdatePickerHeightConstraint = changeConstant(birthdatePickerHeightConstraint, constant: 216)
        UIView.animateWithDuration(0.5, animations: {
            self.birthdatePickerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
        
        dateExpanded = true
        birthdatePickerButton.enabled = false
        licenseExpirationButton.enabled = false
        
        birthdatePicker.setDate(licenseExpirationDate, animated: false)
        isBirthdateSelected = false
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
                    birthdatePickerHeightConstraint = changeConstant(birthdatePickerHeightConstraint, constant: 0)
                    UIView.animateWithDuration(0.5, animations: {
                        self.birthdatePickerView.layoutIfNeeded()
                        self.view.layoutIfNeeded()
                    })
                    dateExpanded = false
                    birthdatePickerButton.enabled = true
                    licenseExpirationButton.enabled = true
                    
                    if isBirthdateSelected {
                        birthdatePickerButton.setTitle(dateFormatter.stringFromDate(birthdatePicker.date), forState: .Normal)
                        birthDate = birthdatePicker.date
                    } else {
                        licenseExpirationButton.setTitle(dateFormatter.stringFromDate(birthdatePicker.date), forState: .Normal)
                        licenseExpirationDate = birthdatePicker.date
                    }
                }
            }
        }
    }
    
    // MARK: - TextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(firstNameTextField.text?.characters.count > 0
            && lastNameTextField.text?.characters.count > 0){
                addButton.tintColor = UIColor(red: 10/255, green: 96/255, blue: 254/255, alpha: 1)
                addButton.enabled = true
        } else {
            addButton.tintColor = UIColor.grayColor()
            addButton.enabled = false
        }
        return true
    }
    
}
