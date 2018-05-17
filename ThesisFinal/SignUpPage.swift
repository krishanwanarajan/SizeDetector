//
//  SignUpPage.swift
//  ThesisFinal
//
//  Created by Krishan Wanarajan on 5/10/18.
//  Copyright © 2018 KrishanWanarajan. All rights reserved.
//

import UIKit
import Firebase

class SignUpPage: UIViewController {
    
    @IBOutlet weak var usernameTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpPage.dismissKeyboard))
        
        viewWillDisappear(true)

        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueButton(_ sender: Any) {
        
        print("Continue Button is Working\n")
        addNewUser()
        
    }
    
    func addNewUser(){
        
        guard let username = usernameTextBox.text else {return}
        guard let email = emailTextBox.text else {return}
        guard let password = passwordTextBox.text else {return}
        
        print("The Username is: \(username)")
        print("The Email is: \(email)")
        print("The Password is: \(password)")
        
        Auth.auth().createUser(withEmail: email, password: password){user, error in
            
            if error == nil && user != nil {
                print("New User created")
                
                let alert = UIAlertController(title: "Success!", message: "You are Signed Up", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("New User Created")
                }))
                self.present(alert, animated: true, completion: nil)
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges{ error in
                    if error == nil {
                        print("User Display Name Changed!!")
                    }
                }
                
            }
            else {
                print("Error Creating User: \(error!.localizedDescription)")
                
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
