//
//  loginViewController.swift
//  lightPi
//
//  Created by Kai Perez on 6/21/16.
//  Copyright © 2016 N/A. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func loginParticle(sender: AnyObject) {
        
        // Two constant variables are created, taking the value of the input the user type for both the password and email fields
        
        let passwordInput = passwordTextField!.text
        let emailInput = emailTextField!.text
        
        // If there was no input in either of the fields, then we will set up an alert to warn the user
        if (passwordInput == "" || emailInput == "") {
            
            // We create the alert object here, and add an ok button that cancels the alert.
            let infoAlert = UIAlertController(title: "Missing information", message: "You didn't enter your email and/or password!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okayButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            infoAlert.addAction(okayButton)
            
            // We actually present the alert right here
            presentViewController(infoAlert, animated: true, completion: nil)
            
            
        } else {
            // If the user typed some input into the text fields, we will then send the input to the Particle server to login in
            
            // Here we pass in the user's email and password from the constant variables we declared earlier
            SparkCloud.sharedInstance().loginWithUser(emailInput!, password: passwordInput!) { (error:NSError?) -> Void in
                if let e=error {
                    
                    // If we were unable to login, then we will create another alert object
                    let wrongCredentialsAlert = UIAlertController(title: "Information Incorrect", message: "Your email and/or password is incorrect!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okayButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                    wrongCredentialsAlert.addAction(okayButton)
                    
                    self.presentViewController(wrongCredentialsAlert, animated: true, completion: nil)
                    print("Wrong credentials or no internet connectivity, please try again")
                }
                else {
                    //print("Logged in")
                    // If we log in successfully, we will then perform the segue to the next screen: the menu screen
                    self.performSegueWithIdentifier("successfulLoginVCSegue", sender: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        presentNavigationLogo()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return false
    }
    
    func presentNavigationLogo() {
        navigationController!.navigationBar.barTintColor = UIColor.lightGrayColor()
        let logo = UIImage(named: "particleHelperLogo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
}