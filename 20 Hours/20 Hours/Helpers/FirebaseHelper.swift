//
//  FirebaseHelper.swift
//  20 Hours
//
//  Created by Scott Chow on 7/12/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import RKDropdownAlert

class FirebaseHelper {
    var notificationSent = true
    var isPracticing = false
    var online = false
    
    var tempSkills : [Skill] = []
    static let sharedInstance = FirebaseHelper()
    let rootRef = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    var completion: (() -> Void)?
    
    func getSkillsRef() -> FIRDatabaseReference?{
        let usersRef = rootRef.child("Users")
        if let user = user {
            
            let uidRef = usersRef.child(user.uid)
            return uidRef.child("Skills")
        }
//        print("user is nil")
        return nil
    }
    
    func getSpecificSkillRef(skill: Skill) -> FIRDatabaseReference? {
        if let skillsRef = self.getSkillsRef() {
//             (skillsRef.child("\(skill.skillName)"))
            return skillsRef.child("\(skill.skillName)")
        } else {
            print("skillsRef is nil")
            return nil
        }
    }
    
    func saveSkill(skill: Skill) {
        if let thisSkillRef = self.getSpecificSkillRef(skill) {
            //creates the root and user id references in the json tree
            let newSkillRef = thisSkillRef
            //sets the value of the reference, either populating it or updating it
            newSkillRef.setValue(skill.toDictionary())
        } else {
            //temp skills should look for whether or not another skill of the same name is present
//            tempSkills.append(skill)
        }

    }

    
    func retrieveSkills() {
        let skillsRef = self.getSkillsRef()
//        var skills : [Skill] = []
        
        
        if let skillsRef = skillsRef {
            skillsRef.observeEventType(.Value, withBlock: { (snapshot) in
                if snapshot.value is NSNull {
                    print("itsempty")
                    self.tempSkills = []
                } else {
//                    print(snapshot.value)
                    self.tempSkills.removeAll()
                    let skillsDictionary = snapshot.value as! NSDictionary
//                    print(skillsDictionary)
                    for (_, valueDictionary) in skillsDictionary {
                        let newSkill = Skill()
                        newSkill.fromDictionary(valueDictionary as! [String : AnyObject])
                        print("Skill added")
                        self.tempSkills.append(newSkill)
                        
                    }
                }
                if let completion = self.completion {
                    completion()
                }
            })
        } else {
            print("unable to retrieve skillsRef")
            RKDropdownAlert.title("Error", message: "Please check your internet connection and try again", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
            
        }
    }
    
    func deleteSkill(skill: Skill, completion: (() -> Void )?) {
        //removes the skill from temp
        
        if let skillToBeDeletedRef = self.getSpecificSkillRef(skill) {
            self.tempSkills = self.tempSkills.filter() { $0.skillName != skill.skillName }
            skillToBeDeletedRef.removeValueWithCompletionBlock({ (error, ref) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                if let completion = completion {
                    completion()
                }
            })
        } else {
            print("could not getSpecificSkillRef")
        }
    }
    
    func detectConnectionState() {
        let connectedRef = FIRDatabase.database().referenceWithPath(".info/connected")
        connectedRef.observeEventType(.Value, withBlock:  { (snapshot) in
            if let connected = snapshot.value as? Bool where connected {
                print("Connected")
                self.online = true
            } else {
                print("Not connected")
                self.online = false
            }
        })
    }
}

enum sendNotification {
    case Practicing, NotPracticing, NotInPracticeViewController
}

enum SortType {
    case AToZ, ZToA, LowToHigh, HighToLow
}
