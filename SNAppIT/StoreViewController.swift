//
//  StoreViewController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 05.04.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit
import MessageUI

class StoreViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Store"
    }

    @IBAction func referDidClick(sender: AnyObject) {
        if !MFMailComposeViewController.canSendMail() {
            UIAlertView(title: "Error", message: "Cannot send a mail", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        let mailComposeController = MFMailComposeViewController()
        mailComposeController.mailComposeDelegate = self
        mailComposeController.setSubject("Join SNAppIT!")
        mailComposeController.setMessageBody(NSString(format: "Use the folowing refer code: %@", "some code"), isHTML: false)
        self.presentViewController(mailComposeController, animated: true, completion: nil)
    }
    
    // MARK: - Mail Compose Controller Delegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}
