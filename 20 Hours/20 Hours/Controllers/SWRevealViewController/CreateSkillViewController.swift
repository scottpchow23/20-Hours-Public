//
//  CreateSkillViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 7/29/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

class CreateSkillViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var skillNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skillNameDidChange(sender: AnyObject) {
        let textField = sender as! UITextField
        if textField.text != "" {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SaveNew") && (skillNameTextField.text != "") {
            let newSkill: Skill = Skill()
            newSkill.skillName = skillNameTextField.text!
            FirebaseHelper.sharedInstance.saveSkill(newSkill)
        } else if segue.identifier == "CancelNew" {
            print("Cancel button tapped")
        }
    }
}
