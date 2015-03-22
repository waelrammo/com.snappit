//
//  SNSnap.swift
//  SNAppIT
//
//  Created by Azat Almeev on 22.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import Foundation
import CoreData

class SNSnap: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var tags: String
    @NSManaged var email: String
    @NSManaged var date: NSDate
    @NSManaged var image: NSData
    @NSManaged var id: NSNumber
    @NSManaged var sended: NSNumber

}
