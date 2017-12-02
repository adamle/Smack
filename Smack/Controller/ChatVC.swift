//
//  ChatVC.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 11/28/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    // Mac-Chat-Api already has socket event for listening on user startType and stopType
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    // Variable
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Bind this view to the keyboard when it appears
        view.bindToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Dynamic table view cell * Remember to set the line of msgBody to 0 (unlimited)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Hide sendBtn when user not edit
        sendBtn.isHidden = true
        
        // Tap to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.tapToDismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Touch button to reveal the sw_rear
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        // Slide to access the sw_rear
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Tap to conceal the sw_rear
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        // Create an observer for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.UserDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        SocketService.instance.getChatMessage { (success) in
            if success {
                self.tableView.reloadData()
                // Scroll the table to the very last message so that the new message will appear
                if MessageService.instance.messages.count > 0 {
                    let lastIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
                }
            }
        }
        
        SocketService.instance.getTypingUser { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return}
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUsersLbl.text = "\(names) \(verb) typing a message"
            } else {
                self.typingUsersLbl.text = ""
            }
        }
        
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
            // Reload data so that no message in table view appears
            tableView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func tapToDismissKeyboard() {
        view.endEditing(true)
    }
    
    // Set up sendBtn appear when user edit
    @IBAction func msgBoxEditingChanged(_ sender: Any) {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return}
        
        if messageTxtBox.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
        } else {
            if isTyping == true {
                sendBtn.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
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
                    // Emit stop typing when user send a message
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
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
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
}














