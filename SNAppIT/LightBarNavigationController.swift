//
//  LightBarNavigationController.swift
//  SNAppIT
//
//  Created by Azat Almeev on 05.04.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class LightBarNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
//    override func supportedInterfaceOrientations() -> Int {
//        let vc = self.topViewController
//        if vc != nil {
//            return vc!.supportedInterfaceOrientations()
//        }
//        else {
//            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
//        }
//    }
//    
//    override func shouldAutorotate() -> Bool {
//        let vc = self.topViewController
//        if vc != nil {
//            return vc!.shouldAutorotate()
//        }
//        else {
//            return true
//        }
//    }
//    
//    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
//        return UIInterfaceOrientation.Portrait
//    }
}
