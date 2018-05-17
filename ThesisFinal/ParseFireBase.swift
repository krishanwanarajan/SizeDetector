//
//  ParseFireBase.swift
//  ThesisFinal
//
//  Created by Krishan Wanarajan on 5/12/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import Foundation
import UIKit

public class parseFirebase {
    
    func printCurrentData(stores: [String], sizes: [String]) -> String {
        
        var dataString: String
        var storeCount: Int
        var sizeCount: Int
        var currentStores: [String]?
        var currentSizes: [String]?
        
        storeCount =  stores.count
        sizeCount = sizes.count
        
        currentStores = stores
        currentSizes = sizes
    
        dataString = "The current number of stores is \(storeCount), which contains the following stores \(String(describing: currentStores))). \nThe current number of different sizes is \(sizeCount), which are \(String(describing: currentSizes))) "
        
        return dataString
        
        
    }
    
    
}
