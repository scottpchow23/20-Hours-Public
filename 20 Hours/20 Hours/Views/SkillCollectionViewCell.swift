//
//  SkillCollectionViewCell.swift
//  20 Hours
//
//  Created by Scott Chow on 7/19/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import MBCircularProgressBar

//protocol MBCircularProgressBarView: class {
//    
//}

class SkillCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var skillNameLabel: UILabel!
    @IBOutlet weak var skillProgressBar: MBCircularProgressBarView!
    

    
    var skill: Skill?

    func runAnimation() {
        if let skill = skill {
            skillProgressBar.value = 0
            
            var skillProgressValue : CGFloat
            if skill.totalTimeSpent > 3600 {
                skillProgressBar.maxValue = CGFloat(20)
                skillProgressValue = floor(CGFloat(skill.totalTimeSpent/3600))
                skillProgressBar.unitString = "h"
            } else if self.skill?.totalTimeSpent > 60 {
                skillProgressBar.maxValue = CGFloat(60)
                skillProgressValue = floor(CGFloat(skill.totalTimeSpent/60))
                skillProgressBar.unitString = "m"
            } else {
                skillProgressBar.maxValue = CGFloat(60)
                skillProgressValue = floor(CGFloat(skill.totalTimeSpent))
                skillProgressBar.unitString = "s"
            }

            skillProgressBar.setValue(skillProgressValue, animateWithDuration: 1)
        } else {
            print("oh no")
        }
    }
    
    func setupNotification() {
        //observer for the .value
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SkillCollectionViewCell.runAnimation), name: "runAnimation", object: nil)
    }
}
