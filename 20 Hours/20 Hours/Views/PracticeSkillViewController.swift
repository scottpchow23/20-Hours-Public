//
//  PracticeSkillViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 6/29/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import LTMorphingLabel

class PracticeSkillViewController: UIViewController {
    @IBOutlet weak var practiceButton: UIButton!
    @IBOutlet weak var skillNameLabel: UILabel!
    @IBOutlet weak var totalTimeSpentLabel: LTMorphingLabel!
    @IBOutlet weak var currentPracticeTimeLabel: LTMorphingLabel!
    
    var skill: Skill!
    var practicing = false
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var currentSession = 0.0
    var practiceSessionElapsedTime = 0.0
    
    let interactor = Interactor()
    var editSkillViewController: EditSkillViewController?
    var googleSearchViewController: GoogleSearchViewController?
    
    override func viewWillAppear(animated: Bool) {
        totalTimeSpentLabel.morphingEffect = .Evaporate
        currentPracticeTimeLabel.morphingEffect = .Evaporate
        if let skill = skill {
            skillNameLabel.text = skill.skillName
            totalTimeSpentLabel.text = SecondsToStringHelper.toString(skill.totalTimeSpent  + practiceSessionElapsedTime)
            practicing = false
            currentPracticeTimeLabel.text = SecondsToStringHelper.toString(practiceSessionElapsedTime)
        } else {
            print("You're practicing a non-existent skill")
        }
        FirebaseHelper.sharedInstance.isPracticing = practicing
        FirebaseHelper.sharedInstance.notificationSent = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(togglePractice), name: UIApplicationWillTerminateNotification, object: AppDelegate.self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //this is where you would check for keeping the timer running while in tutorial
        if (practicing == true) {
            self.togglePractice("finish button pressed before stopping")
        }
        let newSkill = Skill() //doesn't save it when the timer is still running
        newSkill.skillName = skill.skillName
        newSkill.totalTimeSpent = practiceSessionElapsedTime + skill.totalTimeSpent + currentSession
        FirebaseHelper.sharedInstance.saveSkill(newSkill)
        FirebaseHelper.sharedInstance.notificationSent = true
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func updateTimer() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        let elapsedTime = currentTime - startTime + practiceSessionElapsedTime
        currentSession = elapsedTime
        
        currentPracticeTimeLabel.text = SecondsToStringHelper.toString(elapsedTime)
        let totalTime = skill.totalTimeSpent + elapsedTime
        totalTimeSpentLabel.text = SecondsToStringHelper.toString(totalTime)
        
    }
    
    @IBAction func pressedTutorialButton(sender: AnyObject) {
        
        self.performSegueWithIdentifier("toTutorial", sender: nil)
    }
    
    @IBAction func togglePractice(sender: AnyObject) {
        if practicing == false {

            FirebaseHelper.sharedInstance.notificationSent = false
            print(practiceSessionElapsedTime)
            print("Timer start")
            let aSelector: Selector = #selector(PracticeSkillViewController.updateTimer)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            practiceButton.setTitle("Pause", forState: .Normal)
        } else {
            let newSkill = Skill() //doesn't save it when the timer is still running
            newSkill.skillName = skill.skillName
            newSkill.totalTimeSpent = practiceSessionElapsedTime + skill.totalTimeSpent + currentSession
            FirebaseHelper.sharedInstance.saveSkill(newSkill)
            FirebaseHelper.sharedInstance.notificationSent = true
            practiceSessionElapsedTime = currentSession
            print(currentSession)
            currentSession = 0.0
            print(practiceSessionElapsedTime)
            timer.invalidate()
            print("Timer stop")
            practiceButton.setTitle("Resume", forState: .Normal)
        }
        FirebaseHelper.sharedInstance.isPracticing = !practicing
        practicing = !practicing
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "toEdit" {
                editSkillViewController = segue.destinationViewController as? EditSkillViewController
                editSkillViewController?.skillToBeEdited = skill
            }
            if identifier == "toTutorial" {
                //Passing interactor info
                let tabBarController = segue.destinationViewController as! SearchTabBarController
                tabBarController.transitioningDelegate = self
                
                //Passing Search Info
                googleSearchViewController = tabBarController.viewControllers![0] as? GoogleSearchViewController
                let youtubeSearchViewController = tabBarController.viewControllers![1] as? YoutubeSearchViewController
                
                
                googleSearchViewController?.interactor = self.interactor
                youtubeSearchViewController?.interactor = self.interactor
                
                googleSearchViewController?.skill = skill
                googleSearchViewController?.searchString = skill.skillName.stringByReplacingOccurrencesOfString(" ", withString: "+")
            }
        }
    }
    
    @IBAction func unwindToPracticeSkillViewController(segue: UIStoryboardSegue) {
        
    }
}

extension PracticeSkillViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}