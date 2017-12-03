//
//  ChannelVC.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 11/28/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the front look is only 60px when the rear appear
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add an observer to listen to Notif from CreateAccountVC and the MessageChannel
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.UserDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.unreadChannel.append(newMessage.channelId)
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            // Show profile page when user is logged in (loginBtn title == "UserName"
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            // Show login page when user is not logged in (loginBtn title == "Login"
            performSegue(withIdentifier: TO_LOGIN_VC, sender: nil)
        }
    }
    
    // Add AddChannel Modal to the main Channel view
    @IBAction func addChanPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil )
        }
    }
    
    // When a notification of user data changed received, this func will call setupUserInfo
    @objc func UserDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    // Add an observer to receive NOTIF_CHANNELS_LOADED
    @objc func channelsLoaded(_ notif: Notification) {
        tableView.reloadData()
    }
    
    
    // setupUserInfo for 2 cases: (1) user logged in (2) user not logged in
    func setupUserInfo() {
        if AuthService.instance.isLoggedIn == true {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    // Select a channel and post a notification of NOTIF_CHANNELS_SELECTED
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        
        MessageService.instance.selectedChannel = channel
        
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        // Slide back the menu sidebar
        self.revealViewController().revealToggle(animated: true)
        
        // If unread channel was read
        if MessageService.instance.unreadChannel.count > 0 {
            MessageService.instance.unreadChannel = MessageService.instance.unreadChannel.filter{
                // Filtering out item that is seleted - so the selected = read
                $0 != channel.id
            }
        }
        // Reselect the row
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
    }
    
    
    
}













