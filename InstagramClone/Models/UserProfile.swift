//
//  Search.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 04/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import Foundation


struct  UserProfile {
    var userProfileUrl : String?
    var userEmail : String
    var userUid : String
    var userName : String
    var followersCount : Int64?
    var followers : [String]?
    var followingCount : Int64?
    var followings :  [String]?
    init?(data : [String:Any]) {
        guard let userUid = data["uid"] as? String,
            let userEmail = data["emailId"] as? String else {
                return nil
        }
        self.userEmail = userEmail
        self.userUid = userUid
        if let userProfileUrlLink = data["photo"] as? String {
            self.userProfileUrl = userProfileUrlLink
        }
        
        //self.userProfileUrl = data["photo"] as! String
        self.userName = data["name"] as! String
        
        if let followersCountValue = data["followersCount"] as? Int64 {
            self.followersCount = followersCountValue
        }
        
        if let followersArray = data["followers"] as? [String] {
            self.followers = followersArray
        }
        
        if let followingCountValue = data["followingCount"] as? Int64 {
            self.followingCount = followingCountValue
        }
        
        if let followingsArray = data["following"] as? [String] {
            self.followings = followingsArray
        }
    }
    
}
