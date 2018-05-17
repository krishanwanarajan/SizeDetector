//
//  HomePage.swift
//  ThesisFinal
//
//  Created by Krishan Wanarajan on 5/10/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import UIKit
import Firebase

class HomePage: UIViewController {

    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let welcomeText = Auth.auth().currentUser?.displayName
        
        welcomeLabel.text = "Welcome \(welcomeText!)"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        logoutAttempt()
        
    }
    
    func logoutAttempt() {
        
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
