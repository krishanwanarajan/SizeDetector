//
//  ProfilePage.swift
//  ThesisFinal
//
//  Created by Krishan Wanarajan on 5/16/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfilePage: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var profilesTableView: UITableView!
    
    var ref:DatabaseReference?
    var databasehandle:DatabaseHandle?
    
    var profiles = [String]()
    
    var profileNames = [profileInformation]()
    
    var needSizes = [findSize]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        profilesTableView.delegate = self
        profilesTableView.dataSource = self
        
        loadProfiles()

        // Do any additional setup after loading the view.
    }
    @IBAction func addNewProfileButton(_ sender: Any) {
        
        showAddNewProfileInput()
        
    }
    
    func loadProfiles() {
        
        self.profiles.removeAll()
        
        ref = Database.database().reference()
        
        let displayname = Auth.auth().currentUser?.displayName
        
        ref?.observeSingleEvent(of: .value, with: { (profileinformation) in
            for child in profileinformation.childSnapshot(forPath: "ProfileInformation").childSnapshot(forPath: displayname!).children {
                
                let snap = child as! DataSnapshot
                let profile = snap.value as! String
                self.profiles.append(profile)
                
                
                let profilename = profileInformation(profileName: "\(profile)")
                
                self.profileNames.append(profilename)
                print("\(self.profiles)")
                self.profilesTableView.reloadData()
                
            }
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = profilesTableView.dequeueReusableCell(withIdentifier: "profilecell")
        
        cell?.textLabel?.text = profiles[indexPath.row]
        
        return cell!
        
    }
    
    func showAddNewProfileInput() {
        
        let alertController = UIAlertController(title: "Create New Profile", message: "Create New Profile", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title:"Enter", style: .default){(_) in
            
            let displayname = Auth.auth().currentUser?.displayName
            
            let profileName = alertController.textFields?[0].text
            
            self.ref?.child("ProfileInformation").child(displayname!).childByAutoId().setValue(profileName!)
            
            print("\(self.profiles)")
            
            self.loadProfiles()
            
        }
        
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "ProfileName"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // let selectedIndex = indexPath.row
        //storeObjects = indexPath.row
        let selectedIndex = indexPath.row
        
        let hasChildren = sizeforProfile(profile: profiles[selectedIndex])
        
        
        if hasChildren == true
        {
            
          print("Test")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? CameraDetectionPage{
            
            destination.profileInfo = profileNames[(profilesTableView.indexPathForSelectedRow?.row)!]
        
        }
        
        if let destination = segue.destination as? ProfileSizeBrowser {
            
            destination.profileInfo = profileNames[(profilesTableView.indexPathForSelectedRow?.row)!]
            
        }
    }
    
    func sizeforProfile(profile: String) -> Bool {
        
        ref = Database.database().reference()
        
        let displayname = Auth.auth().currentUser?.displayName
        
        ref?.observeSingleEvent(of: .value, with: { (profileSize) in
            
            if profileSize.childSnapshot(forPath: "ProfileInformationSize").childSnapshot(forPath: displayname!).hasChild(profile) == true {
                
                self.performSegue(withIdentifier: "shopBrowser", sender: self)
                
            }
            else {                
                
                self.performSegue(withIdentifier: "gotocamera", sender: self)
                
            }
            
            
        })
        
        print(profile)
        
        return true
        
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
