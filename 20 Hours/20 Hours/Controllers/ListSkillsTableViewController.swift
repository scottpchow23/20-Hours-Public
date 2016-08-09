//
//  ViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 6/28/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import RealmSwift

class ListSkillsTableViewController: UITableViewController {
    
    var skills: [Skill] = [] {
        didSet{
            tableView.reloadData()
        }
    }
   
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            //Deletes the skill from firebase, then resets skills which should cause the table data to reload b/c didset
            FirebaseHelper.sharedInstance.deleteSkill(skills[indexPath.row], completion: {
                self.skills = FirebaseHelper.sharedInstance.tempSkills
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("skillListTableViewCell", forIndexPath: indexPath) as! SkillListTableViewCell
        
        let row = indexPath.row
        let skill = skills[row]
        cell.skillNameLabel.text = skill.skillName
        cell.totalTimeSpentLabel.text = SecondsToStringHelper.toString(skill.totalTimeSpent)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "toPracticeView" {
                
                let indexPath = tableView.indexPathForSelectedRow!
                let skill = skills[indexPath.row]
                let practiceSkillViewController = segue.destinationViewController as! PracticeSkillViewController
                practiceSkillViewController.skill = skill
//                print("Transition to Practice View")
            } else if identifier == "toSkillCreationView" {
//                print("Transition to Skill Creation View")
            }
        }
    }
    
    @IBAction func toLogScreen(sender: AnyObject) {
        
        var segueID = ""
//        print(FirebaseHelper.sharedInstance.user?.anonymous)
        //This should instead check if the user is logged into either facebook OR google
        
        if (FirebaseHelper.sharedInstance.user?.anonymous)! == true {
            segueID = "toLogin"
            
        } else {
            segueID = "toLogout"
        }
        
        self.performSegueWithIdentifier(segueID, sender: nil)
    }
    
    
//    @IBAction func unwindToListSkillsTableViewController(segue: UIStoryboardSegue) {
    
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load")
        
        skills = FirebaseHelper.sharedInstance.tempSkills
        skills.sortInPlace {$0.totalTimeSpent > $1.totalTimeSpent}
//        for skill in skills {
//            print(skill.skillName)
//        }
        
        FirebaseHelper.sharedInstance.getSkillsRef()?.observeEventType(.Value, withBlock: { (snapshot) in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.skills = FirebaseHelper.sharedInstance.tempSkills
//        for skill in self.skills {
//            print(skill)
//        }
        self.skills.sortInPlace {$0.totalTimeSpent > $1.totalTimeSpent}
        self.tableView.reloadData()
        
        FirebaseHelper.sharedInstance.completion = {
            self.skills = FirebaseHelper.sharedInstance.tempSkills
            self.skills.sortInPlace {$0.totalTimeSpent > $1.totalTimeSpent}
            
            self.tableView.reloadData()
        }
    }
}

