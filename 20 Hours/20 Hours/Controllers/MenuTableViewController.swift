//
//  MenuTableViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 7/25/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import DropDown
import RKDropdownAlert

class MenuTableViewController: UITableViewController {
    @IBOutlet weak var dropDownPickerButton: UIButton!
    
    var sortTypePickerDataSource = ["A-Z", "Z-A", "1-9", "9-1"]

    let dropDown = DropDown()

    @IBOutlet weak var logLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSortPickerDropDown()
    }
    
    override func viewWillAppear(animated: Bool) {
        logLabel.text = "Login"
        
        if FirebaseHelper.sharedInstance.user != nil {
            if FirebaseHelper.sharedInstance.user!.anonymous == false {
                logLabel.text = "Logout"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1{
            //sortby
            dropDown.show()
        } else if indexPath.row == 2 {
            if FirebaseHelper.sharedInstance.online == true {
                if (FirebaseHelper.sharedInstance.user?.anonymous)! == true {
                    performSegueWithIdentifier("toLogin", sender: nil)
                    self.revealViewController().revealToggleAnimated(false)

                } else {
                    do {
                        tableView.cellForRowAtIndexPath(indexPath)?.userInteractionEnabled = false
                        try FIRAuth.auth()?.signOut()
                        GIDSignIn.sharedInstance().disconnect()
                        
                        //This should just sign the user into a UNIQUE anonymous user for that unlogged session on that device
                        AuthHelper.signInAnonymously {
                            FirebaseHelper.sharedInstance.completion = {
                                let frontNavViewController = self.revealViewController().frontViewController as? UINavigationController
                                let frontViewController = frontNavViewController?.childViewControllers[0] as? SkillListViewController
                                RKDropdownAlert.title("Logged out", message: "Have a nice day!", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                                self.tableView.cellForRowAtIndexPath(indexPath)?.userInteractionEnabled = true
                                self.revealViewController().revealToggleAnimated(true)
                                frontViewController?.skillCollectionViewController?.skills.removeAll()
                                frontViewController?.skillCollectionViewController?.collectionView?.reloadData()
                            }
                            FirebaseHelper.sharedInstance.retrieveSkills()
                        }
                    } catch {
                        self.tableView.cellForRowAtIndexPath(indexPath)?.userInteractionEnabled = true
                        RKDropdownAlert.title("Error", message: "Failed to logout, try connecting to the internet", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                        
                    }
                }
            } else {
                self.tableView.cellForRowAtIndexPath(indexPath)?.userInteractionEnabled = true
                RKDropdownAlert.title("Error", message: "Try connecting to the internet first!", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                
            }
        } else if indexPath.row == 3 {
            //about
            performSegueWithIdentifier("toAbout", sender: nil)
        } else {
            print("You're selecting a cell that doesn't exist!")
        }
    }
    @IBAction func dropDownPickerButtonPressed(sender: AnyObject) {
        dropDown.show()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("runAnimation", object: nil)
    }
    
    func setUpSortPickerDropDown() {
        dropDown.anchorView = dropDownPickerButton
        dropDown.dataSource = sortTypePickerDataSource
        dropDown.bottomOffset = CGPoint(x: 0, y: dropDownPickerButton.bounds.height)
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.dropDownPickerButton.setTitle(item, forState: .Normal)
            let skillListViewController = self.revealViewController().frontViewController.childViewControllers[0] as? SkillListViewController
            if index == 0 {
                skillListViewController?.skillCollectionViewController!.sortType = .ZToA
            } else if index == 1 {
                skillListViewController?.skillCollectionViewController!.sortType = .AToZ
            } else if index == 2 {
                skillListViewController?.skillCollectionViewController!.sortType = .HighToLow
            } else {
                skillListViewController?.skillCollectionViewController!.sortType = .LowToHigh
            }
            skillListViewController?.skillCollectionViewController?.collectionView?.reloadData()
        }
    }
}
