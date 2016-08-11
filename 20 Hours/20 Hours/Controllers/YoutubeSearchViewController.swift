//
//  YoutubeSearchViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 7/26/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

class YoutubeSearchViewController: UIViewController {

    
    @IBOutlet weak var youtubeSearchBar: UISearchBar!
    @IBOutlet weak var youtubeSearchTableView: UITableView!
    var interactor: Interactor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeSearchTableView.panGestureRecognizer.addTarget(self, action: #selector(YoutubeSearchViewController.handleGesture(_:)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedTutorialButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        
        if(DragToDismissHelper.sharedInstance.dragToDismiss(sender, searchViewController: self, tableView: youtubeSearchTableView, view: view)) {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

extension YoutubeSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlamofireHelper.sharedInstance.youtubeSearch.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("youtubeSearchTableCell") as! YoutubeSearchTableViewCell
        let video = AlamofireHelper.sharedInstance.youtubeSearch[indexPath.row]
        
        cell.videoTitleLabel.text = video.videoTitle
        cell.youtubePlayerView.loadVideoID(video.videoID)
//        print(video.videoID)
//        print(cell.videoURLLabel.text)
        return cell
    }

}

extension YoutubeSearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if youtubeSearchBar.text != nil {
            let searchString = youtubeSearchBar!.text?.stringByReplacingOccurrencesOfString(" ", withString: "+")
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
            if let searchString = searchString {
                AlamofireHelper.sharedInstance.youtubeSearchRequest(searchString) {
                    self.youtubeSearchTableView.reloadData()
                }
            }
        }
    }
}