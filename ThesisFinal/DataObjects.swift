//
//  DataObjects.swift
//  ThesisFinal
//
//  Created by Krishan Wanarajan on 5/13/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import Foundation
import UIKit

class storeObject {
    
    var storeName: String
    var size: String
    
    init(storeName: String, size: String) {
        
        self.storeName = storeName
        self.size = size
        
    }
}

class profileInformation {
    
    var profileName: String
    
    init(profileName: String) {
        
        self.profileName = profileName
        
    }
    
}


class sizeOnly {
    
    var size: String
    
    init(size: String) {
        
        self.size = size
        
    }
    
}


class findSize {
    
    var needSize: Bool
    
    init(needSize: Bool) {
        
        self.needSize = needSize
        
    }
    
}

