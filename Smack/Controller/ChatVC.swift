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
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Bind this view to the keyboard when it appears
        view.bindToKeyboard()
        
        // Tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.tapToDismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // UserDataService.instance.logoutUser()
        // Touch button to reveal the sw_rear
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        // Slide to access the sw_rear
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Tap to conceal the sw_rear
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        // Create an observer for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.UserDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        
        
        // After user close the app and reopen, check if user already logged in
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }

    }
    
    // When a notification of user data changed received, this func will call setupUserInfo
    @objc func UserDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            // Get channels
            channelNameLbl.text = "Smack"
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please login"
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func tapToDismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sendMsgPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return}
            guard let message = messageTxtBox.text else { return}
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageTxtBox.text = ""
                    // Tell the msgTxtBox to resign from its first responder position
                    // and dismiss the keyboard
                    self.messageTxtBox.resignFirstResponder()
                }
            })
        }
    }
    
    func updateWithChannel() {
        // Update "Smack" title with selected channel title
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? "no name"
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                // If at least 1 channel exists, set the first channel as defaul
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No Channel Yet"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelID = MessageService.instance.selectedChannel?.id else { return}
        MessageService.instance.findAllMessagesForChannel(channelID: channelID) { (success) in
            
        }
        
    }
    
}














