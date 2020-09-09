//
//  CircularUIImageView.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 07/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}
