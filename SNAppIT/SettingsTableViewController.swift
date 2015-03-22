//
//  SettingsTableViewController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 16.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var gotoTakePhotoSwitch: UISwitch!
    @IBOutlet weak var gotoMailSwitch: UISwitch!
    @IBOutlet weak var addCodeSwitch: UISwitch!
    @IBOutlet weak var snapsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        self.gotoTakePhotoSwitch.addTarget(self, action: Selector("gotoTakePhotoDidChange:"), forControlEvents: UIControlEvents.ValueChanged)
        self.gotoMailSwitch.addTarget(self, action: Selector("gotoMailDidChange:"), forControlEvents: UIControlEvents.ValueChanged)
        self.addCodeSwitch.addTarget(self, action: Selector("addCodeDidChange:"), forControlEvents: UIControlEvents.ValueChanged)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        self.gotoTakePhotoSwitch.on = defaults.boolForKey("gotoTakePhoto")
        self.gotoMailSwitch.on = defaults.boolForKey("gotoMail")
        self.addCodeSwitch.on = defaults.boolForKey("addCode")
        self.snapsButton.setTitle(NSString(format: "%d snaps", SNSnap.snapCount()), forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoTakePhotoDidChange(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender.on, forKey: "gotoTakePhoto")
        defaults.synchronize()
    }
    
    func gotoMailDidChange(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender.on, forKey: "gotoMail")
        defaults.synchronize()
    }
    
    func addCodeDidChange(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender.on, forKey: "addCode")
        defaults.synchronize()
    }

    // MARK: - Table View Delegate
    

}
