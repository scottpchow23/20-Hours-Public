//
//  DragToDismissHelper.swift
//  20 Hours
//
//  Created by Scott Chow on 8/2/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

class DragToDismissHelper {
    static let sharedInstance = DragToDismissHelper()
    var interactor: Interactor?
    
    func progressAlongAxis(pointOnAxis: CGFloat, axisLength: CGFloat) -> CGFloat {
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }
    
    func dragToDismiss(sender: UIPanGestureRecognizer, searchViewController: UIViewController, tableView: UITableView, view: UIView) -> Bool{
        let percentThreshold: CGFloat = 0.3
        
        let translation = sender.translationInView(view)
        let progress = progressAlongAxis(translation.y, axisLength: view.bounds.height)
        if searchViewController is GoogleSearchViewController {
            let realSearchViewController = searchViewController as! GoogleSearchViewController
            if realSearchViewController.interactor != nil {
                self.interactor = realSearchViewController.interactor
                if let originView = sender.view{
                    switch originView {
                    case view:
                        break
                    case tableView:
                        if tableView.contentOffset.y > 0 {
                            return false
                        }
                    default:
                        break
                    }
                }
                else { return false}
            }
        } else if searchViewController is YoutubeSearchViewController {
            let realSearchViewController = searchViewController as! YoutubeSearchViewController
            if realSearchViewController.interactor != nil {
                self.interactor = realSearchViewController.interactor
                if let originView = sender.view{
                    switch originView {
                    case view:
                        break
                    case tableView:
                        if tableView.contentOffset.y > 0 {
                            return false
                        }
                    default:
                        break
                    }
                }
                else { return false}
            }
        } else {
            print("Typing error; searchViewController's type isn't expected value")

        }
        switch  sender.state {
        case .Began:
            self.interactor!.hasStarted = true
            return true
        //            dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            self.interactor!.shouldFinish = progress > percentThreshold
            self.interactor!.updateInteractiveTransition(progress)
        case .Cancelled:
            self.interactor!.hasStarted = false
            self.interactor!.cancelInteractiveTransition()
            
        case .Ended:
            self.interactor!.hasStarted = false
            self.interactor!.shouldFinish
                ? interactor!.finishInteractiveTransition()
                : interactor!.cancelInteractiveTransition()
        default:
            break
        }
        return false
    }
}
