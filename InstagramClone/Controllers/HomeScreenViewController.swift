//
//  HomeScreenViewController.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 09/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import ProgressHUD
import SDWebImage
class HomeScreenViewController : UIViewController, UITableViewDelegate,UITableViewDataSource,HomePostCommentDelegator{
    
    
    @IBOutlet weak var homeTableView: UITableView!
    let imageCommFunc = ImageCommonFuncs.shared
    var postsArray : [HomePosts] = [HomePosts]()
    var fireAuthObj : Auth?
    var firestoreObj : Firestore?
    var postIdForSelectedItem : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireAuthObj = Auth.auth()
        firestoreObj = Firestore.firestore()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.rowHeight = 542.0
        retrievePosts()
    }
    
    
    //MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePostTableViewCell") as! HomePostTableViewCell
        cell.commentDelegate = self
        let currentItem = postsArray[indexPath.row]
        cell.postImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        if currentItem.userPhoto == "nil" {
            cell.postUserImage.image = UIImage(systemName: "person.crop.circle.fill")
        }else{
            imageCommFunc.loadImage(image: cell.postUserImage, url: currentItem.userPhoto)
        }
        
        imageCommFunc.loadImage(image: cell.postImage, url: currentItem.postUrl)
        
        if currentItem.userWhoLikedArr.contains(UserDetails.sharedUserDetailsInstance.getUserUid()){
            cell.postLikeButton.image = UIImage(systemName: "heart.fill")
        }else {
            cell.postLikeButton.image = UIImage(systemName: "heart")
        }
        
        cell.postDateLabel.text = "Posted on : \(currentItem.postTime)"
        cell.postDescriptionLabel.text = currentItem.postDescription
        cell.postLikeLabel.text = "Likes \(currentItem.userWhoLikedArr.count)"
        cell.postUserName.text = currentItem.userName
        cell.postId = currentItem.postId
        
        return cell
    }
    
    
    func callSegueFromCell(postId: String) {
        self.postIdForSelectedItem = postId
        performSegue(withIdentifier: "CommentSegue", sender: self)
    }
    
    
    //MARK: - Retrieve FireBase Data
    
    func retrievePosts(){
        ProgressHUD.show()
        firestoreObj?.collection("posts").addSnapshotListener({ (querySnapShot, error) in
            print("Triggered")
            self.postsArray.removeAll()
            if error != nil{
                print("Error getting Posts \(error!)")
            }else{
                for document in querySnapShot!.documents{
                    self.postsArray.append(HomePosts(data: document.data()))
                }
                ProgressHUD.dismiss()
                self.homeTableView.reloadData()
            }
        })
    }
    
    
    //MARK: - SignOut Method
    @IBAction func signOutButton(_ sender: UIBarButtonItem) {
        do{
            try fireAuthObj?.signOut()
            removeUserDefaults()
        }catch{
            print("Error While SigningOut")
        }
        self.performSegue(withIdentifier: "signOutSegue", sender: self)
    }
    
    
    func removeUserDefaults(){
        ProgressHUD.show()
        UserDetails.removeUserDefaults {
            ProgressHUD.dismiss()
        }
    }
    
    //MARK: - Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "CommentSegue" {
            let destinationVC = segue.destination as! CommentViewController
            destinationVC.postId = postIdForSelectedItem
        }
    }
    
}
