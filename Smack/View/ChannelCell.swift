//
//  ChannelCell.swift
//  Smack
//
//  Created by Le Dang Dai Duong on 12/2/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.1).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
        
    }
    
    func configureCell(channel: Channel) {
        // If you can find the value there, just return empty string
        let title = channel.channelTitle ?? ""
        channelName.text = "#\(title)"
        
        // Unread channels will be bold
        channelName.font = UIFont(name: "Futura-Regular", size: 20)
        for id in MessageService.instance.unreadChannel {
            if id == channel.id {
                channelName.font = UIFont(name: "Futura-Medium", size: 22)
            }
        }
        
    }

}












