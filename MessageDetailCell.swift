//
//  MessageDetailCell.swift
//  Poke
//
//  Created by Kaiwen Shen on 2/1/20.
//  Copyright © 2020 Kaiwen Shen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class MessageDetailCell: UIViewController {
    
    @IBOutlet weak var recipientImg: UIImageView!
    
    @IBOutlet weak var recipientName: UILabel!
    
    @IBOutlet weak var chatPreview: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
