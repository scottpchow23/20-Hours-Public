//
//  SkillListViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 7/19/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class SkillListViewController: UIViewController {
    
    var skills: [Skill] = [] {
        didSet{
            skillCollectionViewController?.skills = self.skills
        }
    }
    var skillCollectionViewController: SkillCollectionViewController?
    var createSkillViewController: CreateSkillViewController?
    var editSkillViewController: EditSkillViewController?
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var placeholderStackView: UIStackView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().tapGestureRecognizer()
        self.revealViewController().panGestureRecognizer()
        skills = FirebaseHelper.sharedInstance.tempSkills
//        skills.sortInPlace {$0.totalTimeSpent > $1.totalTimeSpent}
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        FirebaseHelper.sharedInstance.getSkillsRef()?.observeEventType(.Value, withBlock: { (snapshot) in
            self.skillCollectionViewController?.collectionView?.reloadData()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.skills = FirebaseHelper.sharedInstance.tempSkills
        
//        self.skills.sortInPlace {$0.totalTimeSpent > $1.totalTimeSpent}
        FirebaseHelper.sharedInstance.completion = {
            self.skills = FirebaseHelper.sharedInstance.tempSkills
//            self.skills.sortInPlace {$0.totalTimeSpent > $1.totalTimeSpent}
            
            self.skillCollectionViewController?.collectionView?.reloadData()
        }
        
        skillCollectionViewController?.skills = self.skills
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSkillListViewController(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            if identifier == "deleteButtonPressed" {
                //implement delete functionality
                print("delete function")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil {
            if segue.identifier == "skillCollectionView" {
                skillCollectionViewController = segue.destinationViewController as? SkillCollectionViewController
                skillCollectionViewController?.skills = self.skills
                skillCollectionViewController?.numOfSkillDelegate = self
            } else if segue.identifier == "toPractice" {
                print("to practice screen")
            } else if segue.identifier == "toCreate" {
                createSkillViewController = segue.destinationViewController as? CreateSkillViewController
            }
        }
    }
}

extension SkillListViewController: ListenForSkills {
    func reportNumOfSkills(numOfSkills: Int) {
        if FirebaseHelper.sharedInstance.tempSkills.count == 0 {
            placeholderStackView.hidden = false
        } else {
            placeholderStackView.hidden = true
        }
    }
}

extension SkillListViewController: SWRevealViewControllerDelegate {
    func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
        if (revealController.frontViewPosition == .Right) {
            revealController.frontViewController.view.userInteractionEnabled = false;
        }
        else {
            revealController.frontViewController.view.userInteractionEnabled = true;
        }
    }
}
