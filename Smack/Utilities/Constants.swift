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

// Segue

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND_TO_CHANNELVC = "unwindToChannelVC"

// UserDefaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Header
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
