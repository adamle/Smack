//
//  UserDataService.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 11/30/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""

    func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }

    func returnUIColor(components: String) -> UIColor {
        
        let scanner = Scanner(string: components)
        let skip = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skip
        
        var r, g, b, a: NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrap = r else {return defaultColor}
        guard let gUnwrap = g else {return defaultColor}
        guard let bUnwrap = b else {return defaultColor}
        guard let aUnwrap = a else {return defaultColor}
        
        let rFloat = CGFloat(rUnwrap.doubleValue)
        let gFloat = CGFloat(gUnwrap.doubleValue)
        let bFloat = CGFloat(bUnwrap.doubleValue)
        let aFloat = CGFloat(aUnwrap.doubleValue)
        
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newUIColor
        
    }
    
    func logoutUser() {
        id = ""
        avatarColor = ""
        avatarName = ""
        email = ""
        name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageService.instance.clearChannels()
    }
    
}









