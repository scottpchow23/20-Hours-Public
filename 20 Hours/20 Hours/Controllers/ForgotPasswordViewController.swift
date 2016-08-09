//
//  ForgotPasswordViewController.swift
//  20 Hours
//
//  Created by Scott Chow on 8/3/16.
//  Copyright © 2016 Scott Chow. All rights reserved.
//

import UIKit
import Firebase
import RKDropdownAlert

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        resetButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func resetButtonPressed(sender: AnyObject) {
        resetButton.enabled = false
        if let email = emailTextField.text {
            FIRAuth.auth()?.sendPasswordResetWithEmail(email) { error in
                if let error = error {
                    self.resetButton.enabled = true
                    RKDropdownAlert.title("Error", message: "\(error.localizedDescription)", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                    
                    print(error.localizedDescription)
                } else {
                    // Password reset email sent.
                    print("reset email sent!")
                    RKDropdownAlert.title("Success!", message: "Password reset email sent!", backgroundColor: UIColor.init(netHex: 0xD02A34), textColor: UIColor.init(netHex: 0xFFFFFF))
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {

}