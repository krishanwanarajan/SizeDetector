//
//  StoreBrowserViewController.swift
//  test
//
//  Created by Krishan Wanarajan on 3/27/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import FirebaseDatabase

class StoreBrowserViewController: UIViewController {

    var ref:DatabaseReference?
    var databasehandle:DatabaseHandle?
    
    @IBOutlet weak var backButtonToMain: UIButton!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var storeBrowserWebView: WKWebView!
    
    var storeObject:storeObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        openBrowserWithWebsite()
        
        
        // Do any additional setup after loading the view.
        storeLabel.text = storeObject?.storeName
        
        let sizetext = "Your size is " + (storeObject?.size)!
        
        sizeLabel.text = sizetext
        
    }

    func openBrowserWithWebsite() {
        
        print("THIS IS A BIG TEST CAN YOU SEE ME")
        
        let storeName: String
        storeName = (storeObject?.storeName)!
        
        ref = Database.database().reference()
        // Gets website URL for the appropriate store
        ref?.observeSingleEvent(of: .value, with: { (urlSnapshot) in
            
            let urlDatasnapshot = urlSnapshot.childSnapshot(forPath: "StoreURL").childSnapshot(forPath: storeName).value
            
            
            print(urlDatasnapshot!)
            
                    let url = URL(string: "\(urlDatasnapshot!)")
                    let request = URLRequest(url: url!)
            
            self.storeBrowserWebView.load(request)
            
            
           // print()
            
        })
        
    
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButtonToMain(_ sender: Any) {
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
