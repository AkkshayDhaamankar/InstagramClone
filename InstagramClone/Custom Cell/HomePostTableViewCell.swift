//
//  HomePostTableViewCell.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 07/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import UIKit
import ProgressHUD
protocol HomePostCommentDelegator {
    func callSegueFromCell(postId : String)
}
class HomePostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var postUserImage: UIImageView!
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postLikeButton: UIImageView!
    @IBOutlet weak var postCommentButton: UIImageView!
    @IBOutlet weak var postSendButton: UIImageView!
    @IBOutlet weak var postBookmarkButton: UIImageView!
    @IBOutlet weak var postLikeLabel: UILabel!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    var postId : String!
    var commentDelegate : HomePostCommentDelegator!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setGestureForImageView()
        postUserImage.setRounded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - ImageClicking Methods
    func setGestureForImageView(){
        let tapLike = UITapGestureRecognizer(target: self, action: #selector(HomePostTableViewCell.tappedLikeButton))
        let tapComment = UITapGestureRecognizer(target: self, action: #selector(HomePostTableViewCell.tappedCommentButton))
        postLikeButton.addGestureRecognizer(tapLike)
        postCommentButton.addGestureRecognizer(tapComment)
        postLikeButton.isUserInteractionEnabled = true
        postCommentButton.isUserInteractionEnabled =  true
    }
    
    @objc func tappedLikeButton()
    {
        
        if postLikeButton.image == UIImage(systemName: "heart"){
            print("Tapped on Like Image")
            ProgressHUD.show()
            FirestoreData.likePost(postId: postId, whoLiked: UserDetails.sharedUserDetailsInstance.getUserUid()) { (boolValue) in
                if boolValue {
                    self.postLikeButton.image = UIImage(systemName: "heart.fill")
                    ProgressHUD.dismiss()
                }
            }
        }else {
            ProgressHUD.show()
            FirestoreData.removeLikeFromPost(postId: postId, whoDisliked: UserDetails.sharedUserDetailsInstance.getUserUid()) { (boolValue) in
                if boolValue {
                    self.postLikeButton.image = UIImage(systemName: "heart")
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
    @objc func tappedCommentButton(){
        print("comment button tapped")
        commentDelegate.callSegueFromCell(postId: postId)
    }
}
