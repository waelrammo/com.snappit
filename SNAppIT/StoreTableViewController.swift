//
//  StoreTableViewController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 16.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit
import MessageUI

class StoreTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var snapsLabel: UILabel!
    var _referView: UIView!
    var referView: UIView {
        get {
            if _referView == nil {
                _referView = UIView(frame: CGRectMake(0, 0, self.view.width, 60))
                _referView.backgroundColor = UIColor.lightGrayColor()
                _referView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
                
                let button = UIButton(frame: _referView.bounds)
                button.setTitle("Refer →", forState: UIControlState.Normal)
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                button.addTarget(self, action: Selector("referDidClick:"), forControlEvents: UIControlEvents.TouchUpInside)
                _referView.addSubview(button)
            }
            return _referView
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Store"
        self.tableView.addSubview(self.referView)
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.referView.height, 0)
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        self.snapsLabel.text = NSString(format: "%d snaps", SNSnap.savedSnaps().count)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.referView.y = self.tableView.height - self.referView.height
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.referView.y = self.tableView.height + scrollView.contentOffset.y - self.referView.height
    }

    func referDidClick(sender: AnyObject) {
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

    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectSelectedRow()
    }

    // MARK: - Mail Compose Controller Delegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
}
