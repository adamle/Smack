//
//  LoginVC.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 11/29/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // Outlets
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
  
    func setupView() {
        spinner.isHidden = true
        setPlaceholderColor(txtField: emailTxt, text: "Email")
        setPlaceholderColor(txtField: passwordTxt, text: "Password")
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = emailTxt.text, emailTxt.text != "" else { return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return}
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    } 
                })
            }
        }
        
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAcctBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT_VC, sender: nil)
    }
    
}
