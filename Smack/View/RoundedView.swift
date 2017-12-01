//
//  RoundedView.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 12/1/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit
@IBDesignable

class RoundedView: UIView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }

}
