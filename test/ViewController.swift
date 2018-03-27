//
//  ViewController.swift
//  test
//
//  Created by Krishan Wanarajan on 12/21/17.
//  Copyright © 2017 KrishanWanarajan. All rights reserved.
//  This is the live version

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    
    @IBOutlet weak var tableStoresSizes: UITableView!
    
    
    var ref:DatabaseReference?
    var databasehandle:DatabaseHandle?
    
    var storeNames = [String]()
    var clothingSizes = [String]()
    
    var storenameAndSize = [String]()
    
    let bound = ["Lower", "Upper"]
    
    var testsize = Double()
    //let testsize = Double(44)
    
    var parsedatabase = parseFirebase()
   // var objects = createStoreObject()
    
    var myIndex = 0
    
    var storeObjects = [storeObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableStoresSizes.delegate = self
        tableStoresSizes.dataSource = self
        
       
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
                           // self.tableStoresSizes.reloadData()
                            
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
                                        
                                            let stringSize = "\(store), \(size)"
                                            
                                            
                                            
                                            let store = storeObject(storeName: "\(store)", size: "\(size)")
                                            self.storeObjects.append(store)
                                            
                                            self.storenameAndSize.append(stringSize)
                                            print(self.storenameAndSize)
                                            self.tableStoresSizes.reloadData()
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
        
        storenameAndSize.removeAll()
       return("\(stores)")
       
    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storenameAndSize.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableStoresSizes.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = storenameAndSize[indexPath.row]
        
        return cell!
        
    }
    
    func printDataToConsole() {
        
        printDataToConsole()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let selectedIndex = indexPath.row
        //storeObjects = indexPath.row
        performSegue(withIdentifier: "segueStoreBrowser", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? StoreBrowserViewController{
            
            destination.storeObject = storeObjects[(tableStoresSizes.indexPathForSelectedRow?.row)!]
            //destination.storeobject =
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var sizeTextField: UITextField!
    
    @IBAction func submitSize(_ sender: Any) {
        
        if self.storenameAndSize.count == 0 {
            print("Submit")
            if let doubleVlaue = Double(sizeTextField.text!){
                
                self.testsize = doubleVlaue
                
                fetchStoreData()
            }
            else
            {
                print("Not a valid number")
            }
        }
        else
        {
            return
        }
        
        self.view.endEditing(true)
    
    }
    
    @IBAction func btnReset(_ sender: Any) {
        
        self.clothingSizes.removeAll()
        self.storeNames.removeAll()
        self.storenameAndSize.removeAll()
        tableStoresSizes.reloadData()
        
        print(self.storenameAndSize)
        
        
    }
    
    
}

