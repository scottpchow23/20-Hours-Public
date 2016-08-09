//
//  AppDelegate.swift
//  20 Hours
//
//  Created by Scott Chow on 6/28/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import RKDropdownAlert

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isTiming: Bool?
    let launchCount  = NSUserDefaults.standardUserDefaults().integerForKey("launchCount")

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        // If the app starts in offline mode, nothing is actually saved; problem with offline Firebase
        FIRDatabase.database().persistenceEnabled = true
        if FIRAuth.auth()?.currentUser == nil {
            AuthHelper.signInAnonymously {
//                FirebaseHelper.sharedInstance.tempSkills.removeAll()
                FirebaseHelper.sharedInstance.retrieveSkills()
            }
        } else {
            FirebaseHelper.sharedInstance.retrieveSkills()
        }
        FirebaseHelper.sharedInstance.detectConnectionState()
        registerForPushNotifications(application)
        NSUserDefaults.standardUserDefaults().setInteger(launchCount+1, forKey: "launchCount")
        NSUserDefaults.standardUserDefaults().synchronize()
        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!, UIApplicationOpenURLOptionsAnnotationKey: annotation]
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation) || FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)

    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
        
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%2.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        // ...
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            // ...
        }
    }

    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!,withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func applicationWillResignActive(application: UIApplication) {
        if FirebaseHelper.sharedInstance.notificationSent == false {
            let notification = UILocalNotification()
            notification.alertBody = "Your practice timer is still running!"
            notification.alertAction = "Open"
            notification.fireDate = NSDate(timeIntervalSinceNow: 1)
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            FirebaseHelper.sharedInstance.notificationSent = true
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        print(FirebaseHelper.sharedInstance.isPracticing)
        if FirebaseHelper.sharedInstance.isPracticing {
            FirebaseHelper.sharedInstance.notificationSent = false
        } else {
            FirebaseHelper.sharedInstance.notificationSent = true
        }
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

