//
//  Functions.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 12/2/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import Foundation

// Set Placeholder Font Color
let SMACKPLACEHOLDERCOLOR = #colorLiteral(red: 0.3515939713, green: 0.4874486923, blue: 0.6412431002, alpha: 0.5)
func setPlaceholderColor(txtField: UITextField, text: String) {
    txtField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor : SMACKPLACEHOLDERCOLOR])
}

