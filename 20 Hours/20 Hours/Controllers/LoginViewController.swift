//
//  LoginViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 7/5/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKLoginKit
import RKDropdownAlert

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    
//    @IBOutlet weak var googleLogInButton: GIDSignInButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailPasswordLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        emailPasswordLoginButton.enabled = true
        // Uncomment to automatically sign in the user.
//        GIDSignIn.sharedInstance().signInSilently()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
    }

    
    @IBAction func emailPasswordLoginButtonPressed(sender: AnyObject) {
        emailPasswordLoginButton.enabled = false
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        if let email = emailTextField.text {
            if email != "" {
                if let password = passwordTextField.text {
                    
                    let skills = FirebaseHelper.sharedInstance.tempSkills
                    
                    FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            RKDropdownAlert.title("Login Failed", message: "\(error!.localizedDescription)", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                            self.emailPasswordLoginButton.enabled = true
                        } else {
                            FirebaseHelper.sharedInstance.completion = {
                                self.performSegueWithIdentifier("loggedIn", sender: nil)
                                print("Login Successful!")
                                RKDropdownAlert.title("Success!", message: "Login Successful!", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                                
                            }
                            FirebaseHelper.sharedInstance.retrieveSkills()
                            for skill in skills {
                                FirebaseHelper.sharedInstance.saveSkill(skill)
                            }
                        }
                    })
                }
            } else {
                emailPasswordLoginButton.enabled = true
                print("email is empty")
                RKDropdownAlert.title( "Login Failed", message: "Please enter a valid email", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                
            }
        
        }
    }
    
    @IBAction func facebookLoginButtonPressed(sender: AnyObject) {
        let login: FBSDKLoginManager = FBSDKLoginManager()
        login.logInWithReadPermissions([], fromViewController: self) { (result, error) in
            if error != nil {
                print(error?.localizedDescription)
                RKDropdownAlert.title("Facebook Login Failed", message: "\(error!.localizedDescription)", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                
            }
            else if result.isCancelled {
//                print("Cancelled")
            }
            else {
//                print("Logged in")
                
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                let skills = FirebaseHelper.sharedInstance.tempSkills
                if error != nil{
                    RKDropdownAlert.title("Error", message: error?.localizedDescription, backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                } else {
                
                    FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                        print("user signed in")
                        FirebaseHelper.sharedInstance.user = user
                        FirebaseHelper.sharedInstance.completion = {
                            RKDropdownAlert.title("Success!", message: "Logged in through Facebook", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                            for skill in skills {
                                FirebaseHelper.sharedInstance.saveSkill(skill)
                            }
                            self.performSegueWithIdentifier("loggedIn", sender: nil)
                        }
                        print(FirebaseHelper.sharedInstance.user?.uid)
                        FirebaseHelper.sharedInstance.retrieveSkills()
                        
//                        print(user?.anonymous)
                    })
                }
//                    print(FIRAuth.auth()?.currentUser?.anonymous)
            }
        }
    }
    
    @IBAction func googleLoginButtonPressed(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //Google SignIn
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
        if error != nil {
            print(error?.localizedDescription)
            RKDropdownAlert.title("Login Failed", message: "\(error!.localizedDescription)", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
            
            return
        } else {
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
            
            let skills = FirebaseHelper.sharedInstance.tempSkills
            print(skills)
           
            
            FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                if error != nil{
                    RKDropdownAlert.title("Error", message: error?.localizedDescription, backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                }else {
                    print("user signed in")
                    FirebaseHelper.sharedInstance.user = user
                    FirebaseHelper.sharedInstance.completion = {
                        RKDropdownAlert.title("Success!", message: "Logged in through Google", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                        for skill in skills {
                            FirebaseHelper.sharedInstance.saveSkill(skill)
                        }
                        self.performSegueWithIdentifier("loggedIn", sender: nil)
                    }
                    //Print the uid of the google user
                    print(FirebaseHelper.sharedInstance.user?.uid)
                    //Retrieve skills from that google user (hopefully)
                    FirebaseHelper.sharedInstance.retrieveSkills()
                }
            })
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
