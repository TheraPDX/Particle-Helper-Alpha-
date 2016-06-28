//
//  viewFunctionsViewController.swift
//  lightPi
//
//  Created by Kai Perez on 6/24/16.
//  Copyright © 2016 N/A. All rights reserved.
//

import UIKit

class ViewFunctionsViewController: UITableViewController {
    
    @IBOutlet var selectionTable: UITableView!
    
    var selectedDevice: SparkDevice?
    
    override func viewDidLoad() {
        
        presentNavigationLogo()
        
        if selectedDevice?.functions.count == 0 {
            let infoAlert = UIAlertController(title: "Function(s) not found", message: "No functions being published by device)", preferredStyle: UIAlertControllerStyle.Alert)
            
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
        return selectedDevice!.functions.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = selectedDevice!.functions[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextScene = segue.destinationViewController as! SendFunctionArgumentViewController
        
        nextScene.selectedDevice = selectedDevice
        if let indexPath = self.selectionTable.indexPathForSelectedRow {
            let selectedFunction = selectedDevice?.functions[indexPath.row]
            nextScene.selectedFunction = selectedFunction
        }
    }
    
    func presentNavigationLogo() {
        navigationController!.navigationBar.barTintColor = UIColor.lightGrayColor()
        let logo = UIImage(named: "particleHelperLogo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
}
