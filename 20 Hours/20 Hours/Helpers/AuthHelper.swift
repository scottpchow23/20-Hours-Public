//
//  AuthHelper.swift
//  20 Hours
//
//  Created by Scott Chow on 7/11/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class AuthHelper {
    
//    var skills = FirebaseHelper.sharedInstance.tempSkills
    
    static func authorize(completion: (()-> Void)?) {
        
        
        self.signInAnonymously { 
            FirebaseHelper.sharedInstance.tempSkills.removeAll()
            if completion != nil {
                completion!()
            }
        }
//        let usersRef = FIRDatabase.database().reference().child("Users")
//        
//        FIRAuth.auth()!.addAuthStateDidChangeListener { (auth, user) in
//            if let user = FIRAuth.auth()!.currentUser {
//                usersRef.child(user.uid)
//                FirebaseHelper.sharedInstance.user = user
//                
//            }
//        }
    }
    
    static func signInAnonymously(completion : (() -> Void)?) {
        let rootRef = FIRDatabase.database().reference()
        let usersRef = rootRef.child("Users")
        FIRAuth.auth()?.signInAnonymouslyWithCompletion() { (user, error) in
            if let completion = completion {
                completion()
            }
            //no offline support so this breaks if no internet connection
//            let isAnonymous = user!.anonymous  // true
//            print(user?.anonymous)
//            let uid = user!.uid
//            let anonUser = AnonUser()
//            
//            anonUser.setUID(uid)
//           RealmHelper.storeAnonUID(anonUser)
        }
        
        FIRAuth.auth()!.addAuthStateDidChangeListener { (auth, user) in
            if let user = FIRAuth.auth()!.currentUser {
                usersRef.child(user.uid)
                FirebaseHelper.sharedInstance.user = user
                
            }
        }
    }
    
    //TO DO: Find a proper home for this function
    static func fireNewDictionary() -> [String: AnyObject] {
        
        let dictionary = [
            "skillName" : "",
            "totalTimeSpent" : 0.0,
            "creationDate" : String(NSDate())
        ]
        
        
        return dictionary as! [String : AnyObject]
    }
}