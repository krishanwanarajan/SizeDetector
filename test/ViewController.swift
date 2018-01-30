//
//  ViewController.swift
//  test
//
//  Created by Krishan Wanarajan on 12/21/17.
//  Copyright © 2017 KrishanWanarajan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var conditionLabel: UILabel!

    var ref:DatabaseReference?
    var databasehandle:DatabaseHandle?
    
    var storeNames = [String]()
    var clothingSizes = [String]()
    
    let bound = ["Lower", "Upper"]
    
    let testsize = ["38"]
    
    var parsedatabase = parseFirebase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            //Set the database reference
            ref = Database.database().reference()
        
            //Gets Store Names from the Database
            ref?.observeSingleEvent(of: .value, with: { (storesnapshot) in
                for child in storesnapshot.childSnapshot(forPath: "Stores").children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    self.storeNames.append(key)
                    
                    

                }
               print(self.storeNames)
            })
        
            //Gets Clothing Sizes from the Database
            ref?.observeSingleEvent(of: .value, with: { (snapshot) in
                for store in self.storeNames {
                    for child in snapshot.childSnapshot(forPath: "SizeGuide").childSnapshot(forPath: "\(store)").childSnapshot(forPath: "Mens").children{
                        let snap = child as! DataSnapshot
                        let key = snap.key
                        
                                if (self.clothingSizes.contains("\(key)") ){
                                    return
                                }
                                else{
                                    self.clothingSizes.append(key)
                                }
                            }
                       print(self.clothingSizes)
                    
                       print(self.parsedatabase.printCurrentData(stores: self.storeNames, sizes: self.clothingSizes))
                    }
                
                })

        
        }
    
    
    
    func printDataToConsole() {

        printDataToConsole()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

