//
//  File.swift
//  20 Hours
//
//  Created by Scott Chow on 6/28/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import Foundation

class Skill {
    
    dynamic var skillName = ""
    dynamic var totalTimeSpent = 0.0
    dynamic var creationDate = NSDate()
    
    func toDictionary() -> [String: AnyObject]{
        
        let dictionary = [
            "skillName": String(skillName),
            "totalTimeSpent": totalTimeSpent,
            "creationDate": String(creationDate)
        ]
        
        return dictionary as! [String: AnyObject]
    }
    
    func fromDictionary(dictionary: [String: AnyObject]) {
//        print (dictionary["skillName"]?.stringValue)
//        print (String(dictionary["skillName"]))
        skillName = String(dictionary["skillName"]!)
        print(skillName)
        totalTimeSpent = dictionary["totalTimeSpent"]!.doubleValue
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        
        creationDate = dateFormatter.dateFromString(String(dictionary["creationDate"]!))!
        
    }
    
}