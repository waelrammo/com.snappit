//
//  SnapDetailsViewController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 16.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit
import MessageUI

class SnapDetailsViewController: UITableViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    var snapImage: UIImage!
    var snapText: String!
    var inputSnap: SNSnap!

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var canEdit: Bool {
        return inputSnap == nil || !inputSnap.isSend
    }
    
    var _formatter: NSDateFormatter!
    var formatter: NSDateFormatter {
        get {
            if _formatter == nil {
                _formatter = NSDateFormatter()
                _formatter.dateStyle = NSDateFormatterStyle.MediumStyle
                _formatter.timeStyle = NSDateFormatterStyle.MediumStyle
            }
            return _formatter
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        self.imageView.image = snapImage
        self.dateLabel.text = formatter.stringFromDate(NSDate())
        if inputSnap != nil {
            self.titleTextField.text = inputSnap.title
            self.tagTextField.text = inputSnap.tags
            self.emailTextField.text = inputSnap.email
            self.dateLabel.text = self.formatter.stringFromDate(inputSnap.date)
            self.imageView.image = UIImage(data: inputSnap.image)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.canEdit {
            self.titleTextField.becomeFirstResponder()
        }
    }
    
    func popToRootControllerAfterSave() {
        let snap = SNSnap.MR_createEntity() as SNSnap
        // FIXME: - set id
//        snap.id = 
        snap.sended = NSNumber(bool: true)
        snap.title = self.titleTextField.text
        snap.tags = self.tagTextField.text
        snap.email = self.emailTextField.text
        snap.date = formatter.dateFromString(self.dateLabel.text!)!
        snap.text = snapText
        snap.image = UIImagePNGRepresentation(self.imageView.image)
        MagicalRecord.saveUsingCurrentThreadContextWithBlockAndWait(nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectSelectedRow()
        if indexPath.row == 5 {
            if !MFMailComposeViewController.canSendMail() {
                UIAlertView(title: "Error", message: "Cannot send a mail", delegate: nil, cancelButtonTitle: "OK").show()
                return
            }
            let mailComposeController = MFMailComposeViewController()
            mailComposeController.mailComposeDelegate = self
            mailComposeController.setSubject(self.titleTextField.text?.stringByAppendingString(" SNAppIT"))
            mailComposeController.setToRecipients([self.emailTextField.text])
//            mailComposeController.setMessageBody(self.tagTextField.text, isHTML: false)
            mailComposeController.setMessageBody(self.snapText, isHTML: false)
            let imageData = UIImageJPEGRepresentation(snapImage, 0.5)
            let recognisedText = self.snapText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            mailComposeController.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "SNAppIT.jpeg")
            mailComposeController.addAttachmentData(recognisedText, mimeType: "text/plain", fileName: "SNAppIT.txt")
            self.presentViewController(mailComposeController, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section) - (self.canEdit ? 0 : 1)
    }
    
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.titleTextField {
            self.tagTextField.becomeFirstResponder()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        else if textField == self.tagTextField {
            self.emailTextField.becomeFirstResponder()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return self.canEdit
    }

    // MARK: - Mail Compose Controller Delegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if result.value == MFMailComposeResultSent.value {
                self.popToRootControllerAfterSave()
            }
        })
    }
}
