//
//  ViewController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 16.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var snapslabel: UILabel!
    
    var shouldGoToCamera: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.snapslabel.text = NSString(format: "%d snaps", SNSnap.snapCount())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appDidBecomeActive:"), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("appWillResignActive:"), name: UIApplicationWillResignActiveNotification, object: nil)
        checkIfShouldOpenCamera()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func appDidBecomeActive(note: NSNotification) {
        checkIfShouldOpenCamera()
    }
    
    func appWillResignActive(note: NSNotification) {
        shouldGoToCamera = nil
    }
    
    func checkIfShouldOpenCamera() {
        if shouldGoToCamera == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            shouldGoToCamera = defaults.boolForKey("gotoTakePhoto")
            if shouldGoToCamera! {
                snappitDidClick(self)
            }
        }
    }

    @IBAction func snappitDidClick(sender: AnyObject) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            UIAlertView(title: "Error", message: "Camera is not available", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    private func moveToSelectPhotoWindow(image: UIImage) {
        self.performSegueWithIdentifier("SelectImage", sender: image)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier? == "SelectImage" {
            let dvc = segue.destinationViewController as SelectImageViewController
            dvc.inputImage = sender as UIImage
        }
    }
    
    //MARK: - Image Picker Delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerOriginalImage] as UIImage
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
            let originalOrientation = image.imageOrientation;
            image = image.rotateByOrientationFlag(originalOrientation)
            UIImageWriteToSavedPhotosAlbum(image, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        })
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideAllHUDsForView(self.view.window, animated: true)
            self.moveToSelectPhotoWindow(image)
        })
    }
}

