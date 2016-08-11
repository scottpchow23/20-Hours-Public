//
//  ViewController.swift
//  20 Hours
//
//  Created by Scott P. Chow on 8/9/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return[self.newTutorialViewController("Welcome"), self.newTutorialViewController("Explanation")]
    }()
    private func newTutorialViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "PageViewIntro", bundle: nil).instantiateViewControllerWithIdentifier(name) 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIPageControl.appearance().backgroundColor = UIColor.init(netHex: 0xB03533)
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .Forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TutorialPageViewController: UIPageViewControllerDataSource {
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            firstViewControllerIndex = orderedViewControllers.indexOf(firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}