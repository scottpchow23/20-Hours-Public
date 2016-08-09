//
//  AnonUser.swift
//  20 Hours
//
//  Created by Scott Chow on 7/14/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import Foundation
import RealmSwift

class AnonUser: Object {
    
    dynamic var uid: String?
    
    func setUID(userID: String) {
        uid = userID
    }
    
    func getUID() -> String? {
        if uid == "" {
            
            print("uid wasn't assigned")
        }
        
        return uid
    }
}