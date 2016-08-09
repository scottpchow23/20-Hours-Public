//
//  RealmHelper.swift
//  20 Hours
//
//  Created by Scott Chow on 6/28/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    static func storeAnonUID(anonUser: AnonUser) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(anonUser)
        }
    }
    
    static func setAnonUID(oldAnonUID: AnonUser, newAnonUID: AnonUser) {
        let realm = try! Realm()
        try! realm.write() {
            oldAnonUID.uid = newAnonUID.uid
        }
    }
    
    static func getAnonUID() -> AnonUser {
        let realm = try! Realm()
        let anonUID = realm.objects(AnonUser)
        return anonUID[0]
    }
    
//    static func addSkill(skill: Skill) {
//        let realm = try! Realm()
//        try! realm.write() {
//            realm.add(skill)
//        }
//        
//        if FirebaseHelper.sharedInstance.user != nil {
//            FirebaseHelper.sharedInstance.saveSkill(skill)
//        }
//        
//    }
//    
//    static func deleteSkill(skill: Skill) {
//        let realm = try! Realm()
//        try! realm.write() {
//            realm.delete(skill)
//        }
//    }
//    
//    static func updateSkill(skillToBeUpdated: Skill, newSkill: Skill) {
//        let realm = try! Realm()
//        try! realm.write() {
//            skillToBeUpdated.totalTimeSpent = newSkill.totalTimeSpent
//        }
//        if FirebaseHelper.sharedInstance.user != nil {
//            FirebaseHelper.sharedInstance.saveSkill(newSkill)
//        }
//    }
//    
//    static func retrieveSkills() -> Results<Skill> {
//        
//        let realm = try! Realm()
//        let skills = realm.objects(Skill).sorted("totalTimeSpent", ascending: false)
//        return skills
//    }
//    
//    static func searchSkills(searchString: String) -> Results<Skill> {
//        let realm = try! Realm()
//        let skills = realm.objects(Skill).filter("skillName = \(searchString)")
//        return skills
//    }
}