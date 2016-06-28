//
//  sendFunctionArgumentView.swift
//  lightPi
//
//  Created by Kai Perez on 6/23/16.
//  Copyright © 2016 N/A. All rights reserved.
//

import UIKit

class SendFunctionArgumentViewController: UIViewController, UITextFieldDelegate {
    
    var selectedFunction: String?
    
    @IBOutlet weak var argumentTextField: UITextField!
    
    @IBAction func sendArgument(sender: AnyObject) {
        
        self.argumentTextField.resignFirstResponder()
        
        var myPhoton : SparkDevice? = nil
        // we use our selectedDevice's id to let the cloud to send the signal to that device
        SparkCloud.sharedInstance().getDevice((selectedDevice?.id)!, completion: { (device:SparkDevice?, error:NSError?) -> Void in
            if let d = device {
                myPhoton = d
                print(myPhoton?.functions)
                
                
                
                let funcArgs = [self.argumentTextField.text!] as [AnyObject]?
                var task = myPhoton!.callFunction(self.selectedFunction!, withArguments: funcArgs) { (resultCode : NSNumber?, error : NSError?) -> Void in
                    if (error == nil) {
                        print("Function argument sent")
                    }
                }
                // var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
                
            }
        })
    }
    
    var selectedDevice: SparkDevice?
    
    override func viewDidLoad() {
        presentNavigationLogo()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        argumentTextField.resignFirstResponder()
        return false
    }
    
    func presentNavigationLogo() {
        navigationController!.navigationBar.barTintColor = UIColor.lightGrayColor()
        let logo = UIImage(named: "particleHelperLogo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
}
