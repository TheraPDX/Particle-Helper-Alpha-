//
//  show.swift
//  lightPi
//
//  Created by Kai Perez on 6/24/16.
//  Copyright © 2016 N/A. All rights reserved.
//

import UIKit

class DeviceListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var menuSelection: UITableView!
    
    var particleDevices : [SparkDevice] = []
    var menuOptionsArr: [String] = [String]()
    var segueIdentifiers: [String] = [String]()
    
    var selectedDevice : SparkDevice?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        self.refreshControl.addTarget(self, action: "tableViewRefreshed", forControlEvents: .ValueChanged)
        self.menuSelection.addSubview(refreshControl)
        presentNavigationLogo()
        
        getData()
        
        // this function is a godsend! Please learn it.
        // run this block after a delay since it takes a few seconds for our array to be appended from the cloud
        runAfterDelay(5.0){
            if self.particleDevices.count == 0 {
                // We create the alert object here, and add an ok button that cancels the alert.
                let infoAlert = UIAlertController(title: "Device(s) not found", message: "No devices linked to account", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okayButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                infoAlert.addAction(okayButton)
                
                // We actually present the alert right here
                self.presentViewController(infoAlert, animated: true, completion: nil)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DeviceCustomCell
        cell.deviceNameLabel.text = particleDevices[indexPath.row].name
        cell.deviceIDLabel.text = "id: \(particleDevices[indexPath.row].id)"
        switch (self.particleDevices[indexPath.row].type)
        {
        case .Core:
            cell.deviceImage.image = UIImage(named: "imgCore")
            cell.deviceTypeLabel.text = "Core"
        case .Electron:
            cell.deviceImage.image = UIImage(named: "imgElectron")
            cell.deviceTypeLabel.text = "Electron"
        case .Photon: // .Photon
            fallthrough
        default:
            cell.deviceImage.image = UIImage(named: "imgPhoton")
            cell.deviceTypeLabel.text = "Photon"
            
            
        }
        
        
        let online = self.particleDevices[indexPath.row].connected
        switch online
        {
        case true :
            cell.deviceStatusLabel.text = "Online"
            cell.deviceStatusImage.image = UIImage(named: "imgGreenCircle")
        default :
            cell.deviceStatusLabel.text = "Offline"
            cell.deviceStatusImage.image = UIImage(named: "imgRedCircle")
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return particleDevices.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if particleDevices[indexPath.row].connected == false {
            // We create the alert object here, and add an ok button that cancels the alert.
            let infoAlert = UIAlertController(title: "Device offline", message: "Make sure your device is turned on.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okayButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            infoAlert.addAction(okayButton)
            
            // We actually present the alert right here
            self.presentViewController(infoAlert, animated: true, completion: nil)
        }
        else{
            selectedDevice = particleDevices[indexPath.row]
            self.performSegueWithIdentifier("selectFunctionOrVariableVCSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectFunctionOrVariableVCSegue" {
            var nextScene = segue.destinationViewController as! SelectFunctionOrVariableViewController
            if let indexPath = menuSelection.indexPathForSelectedRow {
                let selectedDevice = particleDevices[indexPath.row]
                nextScene.selectedDevice = selectedDevice
            }
        }
        if segue.identifier == "logoutSegue" {
            SparkCloud.sharedInstance().logout()
        }
    }
    
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    func presentNavigationLogo() {
        navigationController!.navigationBar.barTintColor = UIColor.lightGrayColor()
        let logo = UIImage(named: "particleHelperLogo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    func tableViewRefreshed() {
        // We use the Photon method to list the devices on the cloud
        //make the call to get the data. Make into function!!
        SparkCloud.sharedInstance().getDevices { (sparkDevices:[AnyObject]?, error:NSError?) -> Void in
            if let _ = error {
                // We create the alert object here, and add an ok button that cancels the alert.
                let infoAlert = UIAlertController(title: "Connection error", message: "Could not connect to the server.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okayButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                infoAlert.addAction(okayButton)
                
                // We actually present the alert right here
                self.presentViewController(infoAlert, animated: true, completion: nil)            }
            else {
                if let devices = sparkDevices as? [SparkDevice] {
                    // This prints a specific part of the JSON
                    let numberOfDevices = devices.count
                    
                    for i in 0..<numberOfDevices {
                        self.particleDevices[i] = devices[i]
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.menuSelection!.reloadData()
                        })
                    }
                }
                
            }
            
        }
        
        self.refreshControl.endRefreshing()
    }
    
    
    
    
    func getData() {
        // We use the Photon method to list the devices on the cloud
        //make the call to get the data. Make into function!!
        SparkCloud.sharedInstance().getDevices { (sparkDevices:[AnyObject]?, error:NSError?) -> Void in
            if let _ = error {
                // We create the alert object here, and add an ok button that cancels the alert.
                let infoAlert = UIAlertController(title: "Connection error", message: "Could not connect to the server.", preferredStyle: UIAlertControllerStyle.Alert)
                
                let okayButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                infoAlert.addAction(okayButton)
                
                // We actually present the alert right here
                self.presentViewController(infoAlert, animated: true, completion: nil)            }
            else {
                if let devices = sparkDevices as? [SparkDevice] {
                    // This prints a specific part of the JSON
                    let numberOfDevices = devices.count
                    
                    for i in 0..<numberOfDevices {
                        self.particleDevices.append(devices[i])
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.menuSelection!.reloadData()
                        })
                    }
                }
                
            }
            
        }
    }
    
    
}
