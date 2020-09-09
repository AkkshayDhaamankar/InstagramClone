//
//  HomePosts.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 09/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import Foundation

class HomePosts {
    var postId : String = ""
    var userName :  String = ""
    var userPhoto : String = ""
    var postUrl :  String = ""
    var postLikeCount : Int = 0
    var postComments : [CommentModel] = [CommentModel]()
    var postBookmark : [String] = [String]()
    var postDescription : String = ""
    var postTime : String = ""
    var postLiked : Bool
    var userWhoLikedArr : [String] = [String]()
    init(data : [String:Any]) {
        self.userName = data["UserName"] as? String ?? "#InstagramName"
        self.userPhoto = data["UserPhoto"] as? String ?? "nil"
        self.postUrl = data["url"] as? String ?? "#InstagramPostUrl"
        self.postLikeCount = data[""] as? Int ?? 0
        self.postComments = data["postComments"] as? [CommentModel] ?? []
        self.postBookmark = data[""] as? [String] ?? ["#InstagramBookmark"]
        self.postDescription = data["description"] as? String ?? "#InstagramDescription"
        self.postTime = data["time"] as? String ?? "#InstagramPostTime"
        self.postLiked = data["postLiked"] as? Bool ?? false
        self.postId = data["postId"] as! String
        self.userWhoLikedArr = data["userWhoLikedArr"] as? [String] ?? []
    }
}
