//
//  SocketService.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 12/2/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    
    // NSObject needs initializer
    override init() {
        super.init()
    }
    
    // Create a variable socket of type SocketIOClient and point to an URL
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    // Establish connection with the server
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    // Client sends an emit to server an event called "newChannel"
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    // Client listens an emit from server an event called "channelCreated"
    func getChannel(completion: @escaping CompletionHandler) {
        // ack = acknowledgement
        socket.on("channelCreated") { (dataArray, ack) in
            // Hash an emit to 3 variables
            guard let channelName = dataArray[0] as? String else { return}
            guard let channelDescription = dataArray[1] as? String else { return}
            guard let channelID = dataArray[2] as? String else { return}
            
            // Create a channel from the received emit
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelID)
            // Append the new channel to MessageService channels array 
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else { return}
            guard let channelId = dataArray[2] as? String else { return}
            guard let userName = dataArray[3] as? String else { return}
            guard let userAvatar = dataArray[4] as? String else { return}
            guard let userAvatarColor = dataArray[5] as? String else { return}
            guard let id = dataArray[6] as? String else { return}
            guard let timeStamp = dataArray[7] as? String else { return}
            
            let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timeStamp)
            
            completion(newMessage)
        }
    }
    
    // Mac-Chat-Api already has socket event for listening on user startType and stopType
    // key - username, value - channelId which the user is typing
    func getTypingUser(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUser = dataArray[0] as? [String: String] else { return}
            completionHandler(typingUser)
        }
        
    }
    
}











