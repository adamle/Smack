//
//  RoundedButton.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 11/30/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit
@IBDesignable

class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}
