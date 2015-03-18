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
    
    override init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        let count = defaults.integerForKey("snapCount") + 1
        self.id = count
        defaults.setInteger(count, forKey: "snapCount")
        defaults.synchronize()
        super.init()
    }
    
    class var documentsDirectory: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        }
    }
    
    class var snapsFile: String {
        get {
            return self.documentsDirectory.stringByAppendingPathComponent("snaps")
        }
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
    
    
    class func savedSnaps() -> [SNSnap] {
        let data = NSData(contentsOfFile: self.snapsFile)
        return data != nil ? NSKeyedUnarchiver.unarchiveObjectWithData(data!) as [SNSnap] : []
    }
    
    class func saveSnaps(snaps: [SNSnap]) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(snaps)
        data.writeToFile(self.snapsFile, atomically: true)
    }
    
    func save() {
        var snaps = SNSnap.savedSnaps()
        snaps.append(self)
        SNSnap.saveSnaps(snaps)
    }
    
    func remove() {
        var snaps = SNSnap.savedSnaps()
        snaps = snaps.filter { (snap) -> Bool in
            return snap.id != self.id
        }
        SNSnap.saveSnaps(snaps)
    }
    
    //MARK: - Coder methods
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt(Int32(self.id), forKey: "id")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.tags, forKey: "tags")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.photo, forKey: "photo")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = Int(aDecoder.decodeIntForKey("id"))
        self.title = aDecoder.decodeObjectForKey("title") as String
        self.tags = aDecoder.decodeObjectForKey("tags") as String
        self.email = aDecoder.decodeObjectForKey("email") as String
        self.date = aDecoder.decodeObjectForKey("date") as NSDate
        self.photo = aDecoder.decodeObjectForKey("photo") as UIImage
    }
}
