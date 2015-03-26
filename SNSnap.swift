//
//  SNAppIT.swift
//  SNAppIT
//
//  Created by Azat Almeev on 26.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import Foundation
import CoreData

class SNSnap: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var email: String
    @NSManaged var id: NSNumber
    @NSManaged var image: NSData
    @NSManaged var sended: NSNumber
    @NSManaged var tags: String
    @NSManaged var title: String
    @NSManaged var text: String

}
