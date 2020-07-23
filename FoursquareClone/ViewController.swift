//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Admin on 7/19/20.
//  Copyright © 2020 nnmax1. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func signinClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { (user, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    //segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }else {
            makeAlert(title: "Error", message: "Username/password not entered")
        }
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground {(success, error) in
                if error != nil {
                    self.makeAlert(title:"Error", message: error!.localizedDescription)
                }else {
                    //segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }else {
            makeAlert(title: "Error", message: "Username/password not entered")
        }
        
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertBtn = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertBtn)
        self.present(alert, animated: true)
        
    }
}

