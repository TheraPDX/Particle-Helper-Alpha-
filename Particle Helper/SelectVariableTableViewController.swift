//
//  readVariableTableViewController.swift
//  lightPi
//
//  Created by Kai Perez on 6/24/16.
//  Copyright © 2016 N/A. All rights reserved.
//

import UIKit

class SelectVariableTableViewController: UITableViewController {
    
    @IBOutlet var menuSelect: UITableView!
    
    var keyValueVariables: [String] = []
    
    var selectedDevice : SparkDevice?
    var selectedVariable: String?
    
    override func viewDidLoad(){
        
        presentNavigationLogo()
        
        
        //god send function for reading a string from dictionary
        for (myKey,myValue) in (selectedDevice?.variables)! {
            print(myValue)
            keyValueVariables.append(myKey)
        }
        
        if keyValueVariables.count == 0 {
            let infoAlert = UIAlertController(title: "Variable(s) not found", message: "No variables being published from device", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okayButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            infoAlert.addAction(okayButton)
            
            // We actually present the alert right here
            presentViewController(infoAlert, animated: true, completion: nil)
            
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyValueVariables.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = keyValueVariables[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("readVariableVCSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var nextScene = segue.destinationViewController as! ReadVariableViewController
        
        if let indexPath = self.menuSelect.indexPathForSelectedRow {
            let selectedVariable = keyValueVariables[indexPath.row]
            
            nextScene.selectedVariable = selectedVariable
            nextScene.selectedDevice = selectedDevice
        }
    }
    
    func presentNavigationLogo() {
        navigationController!.navigationBar.barTintColor = UIColor.lightGrayColor()
        let logo = UIImage(named: "particleHelperLogo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
}