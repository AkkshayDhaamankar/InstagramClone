//
//  CommentModel.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 06/06/1942 Saka.
//  Copyright © 1942 Akshay Dhamankar. All rights reserved.
//

import Foundation

class CommentModel {
    var commentUserName : String = ""
    var commentOfUser : String = ""
    init(commentUserName : String,commentOfUser : String) {
        self.commentOfUser = commentOfUser
        self.commentUserName = commentUserName
    }
}
