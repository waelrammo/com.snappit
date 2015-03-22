//
//  SNSnap.swift
//  SNAppIT
//
//  Created by Azat Almeev on 18.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class SNSnap: NSObject, NSCoding {
    var id: Int
    var title: String!
    var tags: String!
    var email: String!
    var date: NSDate!
    var photo: UIImage!

    
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
}
