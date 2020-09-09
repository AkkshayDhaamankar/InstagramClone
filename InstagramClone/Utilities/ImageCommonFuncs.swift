//
//  ImageCommonFuncs.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 13/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//
import UIKit
import SDWebImage
class ImageCommonFuncs{
    static let shared = ImageCommonFuncs()
    private init() {}
    
    func loadImage(image : UIImageView, url : String){
        image.sd_setImage(with: URL(string: url), placeholderImage: UIImage(systemName: ""),options : []){(image, error, cacheType, url) in
            //self.handleImageResponse(image: image, err: error, cacheType: cacheType, url: url)
        }
    }
}
