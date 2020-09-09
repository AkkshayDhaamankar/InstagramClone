//
//  CommentViewController.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 06/06/1942 Saka.
//  Copyright © 1942 Akshay Dhamankar. All rights reserved.
//

import UIKit
import ProgressHUD
class CommentViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var enterComment: UITextField!
    
    
    
    
    @IBOutlet weak var commentTableView: UITableView!
    var commentsArray : [CommentModel] = [CommentModel]()
    var postId : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.rowHeight = 85.0
        retrieveComments()
    }
    
    
    
    
    //MARK:- TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        
        cell.commentUserName.text = "Sent By :- "+commentsArray[indexPath.row].commentUserName
        cell.commentOfUser.text = "Comment :- "+commentsArray[indexPath.row].commentOfUser
        
        
        return cell
    }
    
    
    //MARK:- Firestore Methods
    func retrieveComments(){
        ProgressHUD.show()
        FirestoreData.getCommentData(postId: postId) { (commentsArray) in
            self.commentsArray = commentsArray
            self.commentTableView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    
    
    
    
    //MARK:- Send Comment Methods
    
    @IBAction func sendComment(_ sender: Any) {
        ProgressHUD.show()
        FirestoreData.sendComment(postId: postId, commentData: CommentModel(commentUserName: UserDetails.sharedUserDetailsInstance.getUserName(), commentOfUser: enterComment.text!)) { (boolValue) in
            if boolValue {
                self.enterComment.text = ""
                ProgressHUD.dismiss()
            }
        }
    }
}
