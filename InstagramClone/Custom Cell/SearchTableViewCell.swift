//
//  SearchTableViewCell.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 04/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userProfile: UIImageView!
    
    
    @IBOutlet weak var userEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
