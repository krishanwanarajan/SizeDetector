//
//  LoginPage.swift
//  ThesisFinal
//
//  Created by Krishan Wanarajan on 5/10/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import UIKit
import Firebase

class LoginPage: UIViewController {
    
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpPage.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        viewWillDisappear(true)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueButton(_ sender: Any) {
        
        print("The Continue Button is pressed")
        print("Calling loginAttempt()")
        
        loginAttempt()
        
    }
    
    func loginAttempt() {
        
        guard let email = emailTextBox.text else {return}
        guard let password = passwordTextBox.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) {user, error in
            if error == nil && user != nil {
                
                print("Sign In Succesfull")
                
                let user = Auth.auth().currentUser
                
                if user != nil
                {
                    self.performSegue(withIdentifier: "credsaccepted", sender: self)
                }
            }
            else {
                print("Error loging in: \(error!.localizedDescription)")
                
                let alert = UIAlertController(title: "Opps..", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("\(error!.localizedDescription)")
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        if (Auth.auth().currentUser == nil) {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        else {
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
