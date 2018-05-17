//
//  ProfileSizeBrowser.swift
//  ThesisFinal
//
//  Created by Krishan Wanarajan on 5/17/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileSizeBrowser: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableStoresSizes: UITableView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    var ref:DatabaseReference?
    var databasehandle:DatabaseHandle?
    
    var storeNames = [String]()
    var clothingSizes = [String]()
    
    var storenameAndSize = [String]()
    
    let bound = ["Lower", "Upper"]
    
    var testsize = Double()
    //let testsize = Double(44)
    
    var parsedatabase = parseFirebase()
    //var objects = createStoreObject()
    
    var myIndex = 0
    
    var storeObjects = [storeObject]()
    
    var profileInfo:profileInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableStoresSizes.delegate = self
        tableStoresSizes.dataSource = self
        
        ref = Database.database().reference()
        
        profileNameLabel.text = profileInfo?.profileName
        
       // fetchSizeForProfile(profileName: (profileInfo?.profileName)!)
        
        self.testsize = 44
        
        fetchStoreData()

        // Do any additional setup after loading the view.
    }
    
    func fetchSizeForProfile(profileName: String){
        
        ref = Database.database().reference()
        
        let displayname = Auth.auth().currentUser?.displayName
        
        databasehandle = ref?.observe(.value, with: { (snapshot) in
            
            let size = snapshot.childSnapshot(forPath: "ProfileInformationSize").childSnapshot(forPath: displayname!).childSnapshot(forPath: (self.profileInfo?.profileName)!).value as! Double
            
            self.testsize = size
            
        })
//        if let size = ref?.child("ProfileInformationSize").child(displayname!).child((profileInfo?.profileName)!) {
//
//            self.testsize = Double(size)!
//
//        }
        
        
        
    }
    
    func fetchStoreData() {
        
        ref?.observeSingleEvent(of: .value, with: {(storesnapshot) in
            for child in storesnapshot.childSnapshot(forPath: "Stores").children {
                
                let snap = child as! DataSnapshot
                let storeKey = snap.key
                self.storeNames.append(storeKey)
                
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
        
        // let selectedIndex = indexPath.row
        //storeObjects = indexPath.row
        performSegue(withIdentifier: "profileToBrowser", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? StoreBrowser{
            
            destination.storeObject = storeObjects[(tableStoresSizes.indexPathForSelectedRow?.row)!]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
