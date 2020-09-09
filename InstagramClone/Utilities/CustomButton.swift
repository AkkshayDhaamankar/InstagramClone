//
//  CustomButton.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 14/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import UIKit

extension UIButton {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    func setBorder(){
        backgroundColor = UIColor.systemTeal
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
    }
}
