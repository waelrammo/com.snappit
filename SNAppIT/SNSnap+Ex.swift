//
//  SNSnap+Ex.swift
//  SNAppIT
//
//  Created by Azat Almeev on 22.03.15.
//  Copyright (c) 2015 Azat Almeev. All rights reserved.
//

import UIKit

extension SNSnap {
    var isSend: Bool {
        get {
            return self.sended.boolValue
        }
    }
    
    class func MR_entityName() -> String {
        return "SNSnap"
    }
    
    class func snapCount() -> UInt {
        return self.MR_countOfEntities()
    }
}
