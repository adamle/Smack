//
//  Constants.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 11/29/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants
let BASE_URL = "https://smackchatty1.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNEL = "\(BASE_URL)channel/"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel/"


// Segue
let TO_LOGIN_VC = "toLogin"
let TO_CREATE_ACCOUNT_VC = "toCreateAccount"
let UNWIND_TO_CHANNEL_VC = "unwindToChannelVC"
let TO_CHOOSE_AVATAR_VC = "toChooseAvatar"

// UserDefaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Header
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]

// Notifaction
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNELS_SELECTED  = Notification.Name("channelsSelected ")











