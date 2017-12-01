//
//  ChatVC.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 11/28/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UserDataService.instance.logoutUser()
        // Touch button to reveal the sw_rear
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        // Slide to access the sw_rear
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Tap to conceal the sw_rear
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        // After user close the app and reopen, check if user already logged in
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        
        // Download all channel when the app launch
        MessageService.instance.findAllChannel { (success) in
            
        }
    }
}






