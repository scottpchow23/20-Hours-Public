//
//  TutorialWebViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 8/1/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

class TutorialWebViewController: UIViewController {

    @IBOutlet weak var tutorialNavBar: UINavigationBar!
    @IBOutlet weak var tutorialWebView: UIWebView!
    var initialURL: NSURL?
    var initialURLTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nsurlRequest = NSURLRequest(URL: initialURL!)
        tutorialNavBar.topItem?.title = initialURLTitle!
        tutorialWebView.loadRequest(nsurlRequest)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension TutorialWebViewController: UIWebViewDelegate {
    
}