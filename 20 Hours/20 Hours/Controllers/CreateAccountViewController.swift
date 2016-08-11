//
//  CreateAccountViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 8/3/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import Firebase
import RKDropdownAlert

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        createAccountButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createButtonPressed(sender: AnyObject) {
        createAccountButton.enabled = false
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        if let email = emailTextField.text {
            if email != "" {
                if let password = passwordTextField.text {
                    if password.characters.count > 7  && password == confirmPasswordTextField.text{
                        
                        let skills = FirebaseHelper.sharedInstance.tempSkills
                        
                        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.createAccountButton.enabled = true
                                print(error?.localizedDescription)
                                RKDropdownAlert.title("Signup Failed", message: "\(error!.localizedDescription)", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                            } else {
                            
                                FirebaseHelper.sharedInstance.completion = {
                                    RKDropdownAlert.title("Success!", message: "Signed up successfully", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                                    self.performSegueWithIdentifier("signedUp", sender: self)
                                }
                                FirebaseHelper.sharedInstance.retrieveSkills()
                                for skill in skills {
                                    FirebaseHelper.sharedInstance.saveSkill(skill)
                                }
                            }
                        })
                    } else {
                        createAccountButton.enabled = true
                        RKDropdownAlert.title("Signup Failed", message: "Passwords must be 8 characters long and match", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                        self.performSegueWithIdentifier("signedUp", sender: self)
                        print("password is not long enough")
                    }
                }
            } else {
                createAccountButton.enabled = true
                print ("email is empty")
                RKDropdownAlert.title("Signup Failed", message: "Please enter a valid email", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                self.performSegueWithIdentifier("signedUp", sender: self)
            }
        }
        
        
    }
}


extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}