//
//  LogoutViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 7/13/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit


class AboutViewController: UIViewController {

    @IBAction func kaufmanButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://tedxtalks.ted.com/video/The-First-20-Hours-How-to-Learn")!)
    }
    
    @IBAction func githubButtonPressed(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/scottpchow23")!)
    }
    
    @IBAction func donateButtonPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.paypal.me/scottpchow23")!)
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
