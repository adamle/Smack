//
//  AddChannelVC.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 12/2/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    // Outlets
    @IBOutlet weak var chanTitle: UITextField!
    @IBOutlet weak var chanDesc: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        setPlaceholderColor(txtField: chanTitle, text: "Channel Title")
        setPlaceholderColor(txtField: chanDesc, text: "Channel Description")
        
        let tapToClose = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.tapToClose(_:)))
        bgView.addGestureRecognizer(tapToClose)
        
        // Set up tap out to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func tapToClose(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChanPressed(_ sender: Any) {
    }
    
}
