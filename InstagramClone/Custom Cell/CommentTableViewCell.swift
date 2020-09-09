//
//  CommentTableViewCell.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 06/06/1942 Saka.
//  Copyright © 1942 Akshay Dhamankar. All rights reserved.
//

import UIKit

class CommentTableViewCell : UITableViewCell{
    
    @IBOutlet weak var commentUserName: UILabel!
    
    @IBOutlet weak var commentOfUser: UILabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
}

