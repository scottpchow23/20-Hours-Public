//
//  GoogleSearchViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 7/26/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

class GoogleSearchViewController: UIViewController {
    
    @IBOutlet weak var googleSearchBar: UISearchBar!
    @IBOutlet weak var googleSearchTableView: UITableView!
    
    var interactor: Interactor?
    
    var tutorialWebViewController: TutorialWebViewController?
    
    var skill: Skill?
    var searchString: String?
    var nsurlToPass: NSURL?
    var nsurlTitleToPass: String?
    
    override func viewWillAppear(animated: Bool) {
        AlamofireHelper.sharedInstance.googleSearchRequest(searchString!) {
            self.googleSearchTableView.reloadData()
        }
        AlamofireHelper.sharedInstance.youtubeSearchRequest(searchString! + "+tutorial", completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        googleSearchTableView.panGestureRecognizer.addTarget(self, action: #selector(GoogleSearchViewController.handleGesture(_:)))
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
//        googleSearchTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressedTutorialButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func progressAlongAxis(pointOnAxis: CGFloat, axisLength: CGFloat) -> CGFloat {
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
                
        if(DragToDismissHelper.sharedInstance.dragToDismiss(sender, searchViewController: self, tableView: googleSearchTableView, view: view)) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension GoogleSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlamofireHelper.sharedInstance.googleSearch.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("googleSearchTableCell") as! GoogleSearchTableViewCell
        let googleSearchs = AlamofireHelper.sharedInstance.googleSearch
        cell.tutorialLinkTitleLabel.text = googleSearchs[indexPath.row].searchTitle
        cell.tutorialLinkURLLabel.text = googleSearchs[indexPath.row].searchDisplayLink
        cell.tutorialURL = googleSearchs[indexPath.row].searchURL
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! GoogleSearchTableViewCell
        let nsurl = NSURL(string: selectedCell.tutorialURL!)
//        print(nsurl)
        
        if UIApplication.sharedApplication().canOpenURL(nsurl!) {
//            print(nsurl)
            nsurlToPass = nsurl
            nsurlTitleToPass = selectedCell.tutorialLinkTitleLabel.text
            self.performSegueWithIdentifier("toTutorialWebView", sender: nil)
        }
    }
    
    @IBAction func unwindToGoogleSearchViewController(segue: UIStoryboardSegue) {
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "toTutorialWebView" {
                tutorialWebViewController =  segue.destinationViewController as? TutorialWebViewController
                tutorialWebViewController?.initialURL = nsurlToPass
                tutorialWebViewController?.initialURLTitle = nsurlTitleToPass
            }
            
        }
    }
}

extension GoogleSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let searchString = googleSearchBar!.text?.stringByReplacingOccurrencesOfString(" ", withString: "+")
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        if searchString != nil {
            AlamofireHelper.sharedInstance.googleSearchRequest(searchString!) {
                self.googleSearchTableView.reloadData()
            }
        }
    }
    
//    searchBarRetu
}