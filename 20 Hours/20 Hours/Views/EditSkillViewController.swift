//
//  CreateSkillViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 6/29/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

class EditSkillViewController: UIViewController {
    @IBOutlet weak var deleteSkillButton: UIButton!
    @IBOutlet weak var skillNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var skillToBeEdited: Skill?
    
    var deleteAlert: UIAlertController? = nil
    
    var showDeleteButton = true
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SaveEdit") && (skillNameTextField.text != "") {
            print("Save button tapped")
            if showDeleteButton {
                if let skillToBeEdited = skillToBeEdited {
                    let practiceSkillViewController = segue.destinationViewController as? PracticeSkillViewController
                    
                    let newSkill: Skill = Skill()
                    newSkill.skillName = skillNameTextField.text!
                    newSkill.totalTimeSpent = skillToBeEdited.totalTimeSpent
                    FirebaseHelper.sharedInstance.saveSkill(newSkill)
                    FirebaseHelper.sharedInstance.deleteSkill(skillToBeEdited, completion: nil)
                    practiceSkillViewController?.skill = newSkill
                }
            } else {
                print("error")
            }
            
        } else if segue.identifier == "CancelEdit" {
            print("Cancel button tapped")
        }
    }

    @IBAction func deleteButtonPressed(sender: AnyObject) {
        if let deleteAlert = deleteAlert {
            self.presentViewController(deleteAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func skillNameChanged(sender: AnyObject) {
        let textField = sender as! UITextField
        if textField.text != "" {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        deleteSkillButton.hidden = !showDeleteButton
        saveButton.enabled = false
        if showDeleteButton {
            skillNameTextField.text = skillToBeEdited?.skillName
            self.deleteAlert = UIAlertController(title: "Delete This Skill", message: "Are you sure you want to delete this skill? All progress on it will be lost.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Nevermind", style: .Cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "I'm sure", style: .Default) { (deleteSkill) in
                if let skillToBeEdited = self.skillToBeEdited {
                    FirebaseHelper.sharedInstance.deleteSkill(skillToBeEdited, completion: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
            self.deleteAlert!.addAction(cancelAction)
            self.deleteAlert!.addAction(deleteAction)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
