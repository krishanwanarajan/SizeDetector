//
//  ParseFireBase.swift
//  test
//
//  Created by Krishan Wanarajan on 1/24/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import Foundation
import UIKit
//import Firebase
//import FirebaseDatabase


public class parseFirebase {

//    var ref:DatabaseReference?
//    var databasehandle:DatabaseHandle?
    
    
    
    //This function will print out the data that is currently stored in the database
    func printCurrentData(stores: [String], sizes: [String]) -> String{
        
        var dataString: String
        var storeCount: Int
        var sizeCount: Int
        var currentStores: [String]?
        var currentSizes: [String]?
        
        storeCount = stores.count
        sizeCount = sizes.count
        
        currentStores = stores
        currentSizes = sizes
        
        dataString = "The current number of stores is \(storeCount), which contains the following stores \(String(describing: currentStores)). \nThe current number of different sizes is \(sizeCount), which are \(String(describing: currentSizes)) "
        
        return dataString
        
    }
    
//    func printStoreSizeData(size: String){
//
//        ref = Database.database().reference()
//
//
//        return storeAndSize
//
//
//
//    }
    
}


