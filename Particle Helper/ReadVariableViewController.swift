//
//  readVariableVC.swift
//
//
//  Created by Kai Perez on 6/25/16.
//
//

import UIKit

class ReadVariableViewController: UIViewController{
    
    @IBOutlet weak var variableTitleTextLabel: UILabel!
    
    @IBOutlet weak var variableValueTextLabel: UILabel!
    
    @IBAction func updateVariable(sender: AnyObject) {
        getVariableValue()
        variableTitleTextLabel.text = "Variable: \(selectedVariable!)"
    }
    var selectedVariable: String?
    var selectedDevice: SparkDevice?
    
    override func viewDidLoad() {
        presentNavigationLogo()
        getVariableValue()
        //updateDisplay()
    }
    
    
    var variableReading: Int?
    
    func getVariableValue() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.selectedDevice!.getVariable(self.selectedVariable!, completion: { (result:AnyObject?, error:NSError?) -> Void in
                if let e=error {
                    print("Failed reading temperature from device")
                }   else {
                    if let reading = result as? Int {
                        self.variableReading = reading
                        self.updateDisplay()
                    }
                }
            })
            self.variableTitleTextLabel.reloadInputViews()
            self.variableValueTextLabel.reloadInputViews()
        })
    }
    
    func updateDisplay() {
        variableValueTextLabel.text = "Result: \(variableReading!)"
        variableTitleTextLabel.text = "Variable: \(selectedVariable!)"
    }
    
    func presentNavigationLogo() {
        navigationController!.navigationBar.barTintColor = UIColor.lightGrayColor()
        let logo = UIImage(named: "particleHelperLogo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
}
