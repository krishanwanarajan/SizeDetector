//
//  ViewController.swift
//  ThesisFinal
//
//  Created by Krishan Wanarajan on 5/10/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
        let user = Auth.auth().currentUser
   
        if user != nil {
            self.performSegue(withIdentifier: "startToHome", sender: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

