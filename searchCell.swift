//
//  searchCell.swift
//  Poke
//
//  Created by Kaiwen Shen on 6/14/20.
//  Copyright © 2020 Kaiwen Shen. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import FirebaseDatabase
import FirebaseStorage


class searchCell: UITableViewCell {

    @IBOutlet weak var userimage: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    var searchDetail: Search!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCell(searchDetail: Search) {
        self.searchDetail = searchDetail
        
        nameLbl.text = searchDetail.username
        
        let ref = Storage.storage().reference(forURL: searchDetail.userImg)
        
        ref.getData(maxSize: 1000000, completion: {(data, error) in
            if error != nil {
                print("We couldn't upload the image.")
                
            } else {
                if let imgData = data {
                    if let img = UIImage(data: imgData) {
                        self.userimage.image = img
                    }
                }
            }
        })
    }
}
