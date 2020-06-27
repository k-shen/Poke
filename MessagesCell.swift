//
//  MessagesCell.swift
//  Poke
//
//  Created by Kaiwen Shen on 6/13/20.
//  Copyright © 2020 Kaiwen Shen. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MessagesCell: UITableViewCell {

    @IBOutlet weak var receivedMessageLbl: UILabel!
    
    @IBOutlet weak var receivedMessageView: UIView!
    
    @IBOutlet weak var sentMessageLbl: UILabel!
    
    @IBOutlet weak var sentMessageView: UIView!
    
    var message: Message!
    
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCell(message: Message) {
        self.message = message
        
        if message.sender == currentUser {
            sentMessageView.isHidden = false
            
            sentMessageLbl.text = message.message
            
            receivedMessageLbl.text = ""
            
            receivedMessageLbl.isHidden = true
        } else {
            sentMessageView.isHidden = true
            
            sentMessageLbl.text = ""
            
            receivedMessageLbl.text = message.message
            
            receivedMessageLbl.isHidden = false
        }
    }
}
