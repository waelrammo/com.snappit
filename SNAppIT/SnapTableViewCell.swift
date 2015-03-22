//
//  SnapTableViewCell.swift
//  SNAppIT
//
//  Created by Azat Almeev on 22.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

class SnapTableViewCell: UITableViewCell {

    @IBOutlet weak var snapTitle: UILabel!
    @IBOutlet weak var snapSubtitle: UILabel!
    @IBOutlet weak var snapDate: UILabel!
    
    class func nib() -> UINib {
        return UINib(nibName: "SnapTableViewCell", bundle: nil)
    }
    
    class func identifier() -> String {
        return "snapCell"
    }
    
    var _formatter: NSDateFormatter!
    var formatter: NSDateFormatter {
        get {
            if _formatter == nil {
                _formatter = NSDateFormatter()
                _formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                _formatter.timeStyle = NSDateFormatterStyle.NoStyle
            }
            return _formatter
        }
    }
    
    func configureWithSnap(snap: SNSnap) {
        self.snapTitle.text = snap.title
        self.snapSubtitle.text = snap.tags
        self.snapDate.text = self.formatter.stringFromDate(snap.date)
    }
    
}
