//
//  TutorialWebViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 8/1/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import WebKit

class TutorialWebViewController: UIViewController {

    @IBOutlet weak var webViewFrame: UIView!
    @IBOutlet weak var tutorialNavBar: UINavigationBar!
    var initialURL: NSURL?
    var initialURLTitle: String?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        webView = WKWebView(frame: webViewFrame.bounds)
        webView.navigationDelegate = self
        webViewFrame.insertSubview(webView, atIndex: 0)
        
        let nsurlRequest = NSURLRequest(URL: initialURL!)
        tutorialNavBar.topItem?.title = initialURLTitle!
        webView.loadRequest(nsurlRequest)
        webView.allowsBackForwardNavigationGestures = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func forwardButtonPressed(sender: AnyObject) {
        if webView.canGoForward {
            webView.goForward()
        }
        
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        webView.reload()
    }
}

extension TutorialWebViewController: WKNavigationDelegate {
    
}