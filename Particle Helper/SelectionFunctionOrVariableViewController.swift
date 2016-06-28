//
//  selectFunctionOrVariableViewController.swift
//  lightPi
//
//  Created by Kai Perez on 6/24/16.
//  Copyright © 2016 N/A. All rights reserved.
//

import UIKit

class SelectFunctionOrVariableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var selectionTable: UITableView!
    
    let functionOrVariableArr: [String] = ["View Functions", "View Variables"]
    var selectedDevice: SparkDevice?
    
    
    override func viewDidLoad(){
        presentNavigationLogo()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = functionOrVariableArr[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if functionOrVariableArr[indexPath.row] == "View Functions" {
            self.performSegueWithIdentifier("functionViewVCSegue", sender: self)
        }
        else if functionOrVariableArr[indexPath.row] == "View Variables" {
            self.performSegueWithIdentifier("variableSelectVCSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "functionViewVCSegue" {
            let nextScene = segue.destinationViewController as! ViewFunctionsViewController
            nextScene.selectedDevice = selectedDevice
            
        } else if segue.identifier == "variableSelectVCSegue" {
            let nextScene = segue.destinationViewController as! SelectVariableTableViewController
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
