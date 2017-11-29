//
//  GradientView.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 11/29/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit
@IBDesignable // Render in design time

class GradientView: UIView {
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1) {
        // This code allows us to change color  in Storyboard
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) {
        // This code allows us to change color  in Storyboard
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // When we change the view, we need this function to override the view
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        // Add this CA Gradient Layer to the view, at the first layer (index 0)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
