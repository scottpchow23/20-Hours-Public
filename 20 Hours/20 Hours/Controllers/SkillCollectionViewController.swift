//
//  CollectionViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 7/19/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SkillCell"

class SkillCollectionViewController: UICollectionViewController {
    
    var skills: [Skill] = [] {
        didSet{
            collectionView?.reloadData()
        }
    }
    
    var sortType = SortType.HighToLow
    
    var appFirstStartUp: Bool = true
    
    var numOfSkillDelegate: ListenForSkills?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("runAnimation", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        sortSkills()
        numOfSkillDelegate?.reportNumOfSkills(skills.count)
        return skills.count
    }
    
    func postNotif() {
        NSNotificationCenter.defaultCenter().postNotificationName("runAnimation", object: nil)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SkillCollectionViewCell
        cell.skill = skills[indexPath.row]
        print(cell.skill?.skillName)
        cell.skillProgressBar.value = 0
        cell.skillProgressBar.progressColor = UIColor(netHex: 0xe74c3c)
        cell.skillProgressBar.progressStrokeColor = UIColor(netHex: 0xe74c3c)
        
        cell.skillNameLabel.text = skills[indexPath.row].skillName
        cell.skillProgressBar.progressLineWidth = 1
        if skills[indexPath.row].totalTimeSpent > 3600 {
            cell.skillProgressBar.maxValue = CGFloat(20)
            cell.skillProgressBar.unitString = "h"
        } else if skills[indexPath.row].totalTimeSpent > 60 {
            cell.skillProgressBar.maxValue = CGFloat(60)
            cell.skillProgressBar.unitString = "m"
        } else {
            cell.skillProgressBar.maxValue = CGFloat(60)
            cell.skillProgressBar.unitString = "s"
        }
        cell.setupNotification()
        if indexPath.row == skills.count - 1 && appFirstStartUp {
            appFirstStartUp = false
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.postNotif), userInfo: nil, repeats: false)
//
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        let skillCell = cell as! SkillCollectionViewCell
//        skillCell.runAnimation()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toPractice", sender: skills[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "toPractice" {
                let destinationViewController = segue.destinationViewController as! PracticeSkillViewController
                
                destinationViewController.skill = sender as! Skill
            }
        }
    }
    
    func sortSkills() {
        switch sortType {
        case .AToZ:
            skills.sortInPlace {$0.skillName < $1.skillName}
        case .ZToA:
            skills.sortInPlace {$0.skillName > $1.skillName}
        case .HighToLow:
            skills.sortInPlace {$0.totalTimeSpent > $1.totalTimeSpent}
        case .LowToHigh:
            skills.sortInPlace {$0.totalTimeSpent < $1.totalTimeSpent}
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension SkillCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds
        print(UIDevice.currentDevice().orientation.rawValue)
        if UIDeviceOrientationIsValidInterfaceOrientation(UIDevice.currentDevice().orientation) && UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) {
            //landscape setup
            let size: CGSize = CGSize(width: (screenSize.height)/2.5, height: ((screenSize.height)/2)*0.8)
            return size
        } else {
            //
            let size: CGSize = CGSize(width: (screenSize.width)/2.5, height: ((screenSize.width)/2)*0.8)
            return size
        }
    
    }
}

protocol ListenForSkills {
    func reportNumOfSkills(numOfSkills: Int)
}