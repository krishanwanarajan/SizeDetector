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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    
    @IBOutlet weak var tableStoresSizes: UITableView!
    
    
    var ref:DatabaseReference?
    var databasehandle:DatabaseHandle?
    
    var storeNames = [String]()
    var clothingSizes = [String]()
    
    
    let bound = ["Lower", "Upper"]
    
    let testsize = Double(44)
    
    var parsedatabase = parseFirebase()
    var objects = createStoreObject()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableStoresSizes.delegate = self
        tableStoresSizes.dataSource = self
        
        fetchStoreData()
        //printStoreToSizeData()

        //Set the database reference
        ref = Database.database().reference()
        
        }
  
    func fetchStoreData() {
        //Set the database reference
         ref = Database.database().reference()
       // Gets Store Names from the Database
                    ref?.observeSingleEvent(of: .value, with: { (storesnapshot) in
                        for child in storesnapshot.childSnapshot(forPath: "Stores").children {
                            let snap = child as! DataSnapshot
                            let StoreKey = snap.key
                            self.storeNames.append(StoreKey)
                            self.tableStoresSizes.reloadData()
                            
                        }
                    })
        
        
        
        //Gets Clothing Sizes from the Database
        ref?.observeSingleEvent(of: .value, with: { (snapshot) in
            for store in self.storeNames {
                for child in snapshot.childSnapshot(forPath: "SizeGuide").childSnapshot(forPath: "\(store)").childSnapshot(forPath: "Mens").children{
                    let snap = child as! DataSnapshot
                    let SizeKey = snap.key
                    
                    if (self.clothingSizes.contains("\(SizeKey)") ){
                        continue
                    }
                    else{
                        self.clothingSizes.append(SizeKey)
                    }
                }
            }
            print(self.printStoreToSizeData(tempStores: self.storeNames, tempSizes: self.clothingSizes))
        })
    
    }
    
    
    func printStoreToSizeData(tempStores: [String], tempSizes: [String]) -> String {
        
        let stores = tempStores
        let sizes = tempSizes
        
        print(stores)
        
        ref = Database.database().reference()
        // Gets Store Names from the Database
        for store in stores {
            for size in sizes {
    
                ref?.observeSingleEvent(of: .value, with: { (storesize) in
                    
                    if storesize.childSnapshot(forPath: "SizeGuide").childSnapshot(forPath: store).childSnapshot(forPath: "Mens").hasChild(size) {
                        
                        self.ref?.child("SizeGuide").child(store).child("Mens").child(size).child("Lower").observe(.value, with: { (sizeComparison) in
                            
                            let post = sizeComparison.value as! Double
                            let postInt = post
        
                            if self.testsize >= postInt  {
                                
                                self.ref?.child("SizeGuide").child(store).child("Mens").child(size).child("Upper").observe(.value, with: { (upperSizeComparison) in
                                
                                    let upper = upperSizeComparison.value as! Double
                                    let upperDouble = upper
                                    
                                        if self.testsize <= upperDouble  {
                                        
                                            print("The size matches up to \(self.testsize) for the store: \(store), which is the following size \(size)")
                                            return
                                        }
                                        else
                                        {
                                            return
                                        }
                                })
                            }
                            else
                            {
                                return
                            }
                        })
                    }
                    else
                    {
                        return
                    }
                    
                })
            }
        }
       return("\(stores)")
       
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableStoresSizes.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = storeNames[indexPath.row]
        
        return cell!
        
    }
    
    func printDataToConsole() {
        
        printDataToConsole()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}

