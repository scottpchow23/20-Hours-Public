//
//  DismissAnimator.swift
//  20 Hours
//
//  Created by Scott Chow on 8/1/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject {
    
}

extension DismissAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let containerView = transitionContext.containerView()
        else {
            return
        }
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        //hide the view controller; we're using snapshots
        fromViewController.view.hidden = true
        //create the snapshot
        let snapshot = fromViewController.view.snapshotViewAfterScreenUpdates(false)
        //add the snapshot
        containerView.insertSubview(snapshot, aboveSubview: toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            //move the snapshot down a screen length
            snapshot.center.y += UIScreen.mainScreen().bounds.height
            }) { _ in
                //Cleanup
                //undo hidden state; the user won't see because the transition is already over
                fromViewController.view.hidden = false
                // It's already off-screen so clean the snapshot
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}