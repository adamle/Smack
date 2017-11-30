//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 11/29/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    // Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func createAcctPressed(_ sender: Any) {
        // Grab value from email and password textfield
        guard let email = emailTxt.text, emailTxt.text != "" else { return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else { return}
    
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("register user")
            }
        }
    }
    
    @IBAction func chooseAvaPressed(_ sender: Any) {
    }
    
    @IBAction func genBgColorPressed(_ sender: Any) {
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNELVC, sender: nil)
    }
    
}
