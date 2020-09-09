//
//  FirestoreData.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 14/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import Foundation
import Firebase
import ProgressHUD
class FirestoreData {
    private init(){}
    static let fireStoreObject : Firestore = Firestore.firestore()
    static let storageRef = Storage.storage().reference()
    
    static func retrieveUsers(completionHandler : @escaping ([UserProfile]) -> Void ){
        var userDataArr : [UserProfile] = [UserProfile]()
        
        fireStoreObject.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //  print("\(document.documentID) => \(document.data())")
                    if document.data()["uid"] as! String != UserDetails.sharedUserDetailsInstance.getUserUid() {
                        userDataArr.append(UserProfile(data: document.data())!)
                        print(userDataArr.count)
                    }
                }
                completionHandler(userDataArr)
            }
        }
    }
    
    static func retrieveSingleUser(userUid : String,completionHandler : @escaping (UserProfile, [HomePosts]) -> Void){
        var homePostsArr : [HomePosts] = [HomePosts]()
        fireStoreObject.collection("users").document(userUid).addSnapshotListener{ (documentSnapShot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else {
                let userData : UserProfile = UserProfile(data: (documentSnapShot?.data())!)!
                fireStoreObject.collection("posts").whereField("uid", isEqualTo: userUid).getDocuments { (querySnapShot, err) in
                    homePostsArr.removeAll()
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }else {
                        for document in querySnapShot!.documents {
                            homePostsArr.append(HomePosts(data: document.data()))
                        }
                        completionHandler(userData,homePostsArr)
                    }
                }
            }
        }
        
    }
    
    static func uploadProfilePic(image : UIImage, userUid : String, imageName : String, whichCollection collection : String, completionHandler : @escaping (String) -> Void) {
        let imageRef = storageRef.child(collection+"/"+userUid+"/"+imageName)
        imageRef.putData((image.pngData())!, metadata: nil) { (metadata, error) in
            if metadata == nil {
                // Uh-oh, an error occurred!
                return
            }
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                self.updateProfileUrl(uid: userUid, url: downloadURL.absoluteString, completionHandler: completionHandler)
            }
        }
    }
    
    private static func updateProfileUrl(uid :  String,url : String, completionHandler : @escaping (String) -> Void){
        fireStoreObject.collection("users").document(uid).updateData(["photo" : url]) { (error) in
            if error != nil{
                print(error!)
            }else {
                fireStoreObject.collection("posts").whereField("uid", isEqualTo: uid).getDocuments { (querySnapShot, error) in
                    for document in querySnapShot!.documents {
                        fireStoreObject.collection("posts").document(document.documentID).updateData(["UserPhoto" : url]) { (error) in
                            if error != nil {
                                print("error while updating posts photo url")
                            }else {
                                completionHandler(url)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    static func addFollowData(otherUserUid : String, currentUserUid : String, completionHandler : @escaping (Bool) -> Void){
        fireStoreObject.collection("users").document(otherUserUid).setData([
            "followers": FieldValue.arrayUnion([currentUserUid]),"followersCount" : FieldValue.increment(Int64(1))
        ],merge: true) { (error) in
            if error != nil{
                print("error while following user")
            }else {
                fireStoreObject.collection("users").document(currentUserUid).setData(["followingCount": FieldValue.increment(Int64(1)),"following": FieldValue.arrayUnion([otherUserUid])],merge: true) { (errorInner) in
                    if errorInner != nil{
                        print("error while following user")
                    }else{
                        completionHandler(true)
                    }
                }
            }
        }
    }
    static func removeFollowData(otherUserUid : String, currentUserUid : String, completionHandler : @escaping (Bool) -> Void){
        fireStoreObject.collection("users").document(otherUserUid).updateData([
            "followers": FieldValue.arrayRemove([currentUserUid]),"followersCount" : FieldValue.increment(Int64(-1))
        ]) { (error) in
            if error != nil{
                print("error while following user")
            }else {
                fireStoreObject.collection("users").document(currentUserUid).updateData(["followingCount": FieldValue.increment(Int64(-1)),"following": FieldValue.arrayRemove([otherUserUid])]) { (errorInner) in
                    if errorInner != nil{
                        print("error while following user")
                    }else{
                        completionHandler(true)
                    }
                }
            }
        }
    }
    
    
    static func likePost(postId : String,whoLiked userUid : String,completionHandler : @escaping(Bool) -> Void){
        fireStoreObject.collection("posts").document(postId).setData(["userWhoLikedArr": FieldValue.arrayUnion([userUid])], merge: true) { (error) in
            if error != nil {
                print(error!)
            }else{
                completionHandler(true)
            }
        }
    }
    
    static func removeLikeFromPost(postId : String,whoDisliked userUid : String,completionHandler : @escaping(Bool) -> Void){
        fireStoreObject.collection("posts").document(postId).updateData(["userWhoLikedArr": FieldValue.arrayRemove([userUid])]) { (error) in
            if error != nil {
                print(error!)
            }else{
                completionHandler(true)
            }
        }
    }
    static func sendComment(postId: String, commentData : CommentModel, completionHandler : @escaping (Bool) -> Void){
        fireStoreObject.collection("posts").document(postId).collection("comments").document().setData(["commentOfUser" : commentData.commentOfUser,"commentUserName" : commentData.commentUserName]) { (error) in
            if error != nil {
                print(error!)
            }else{
                completionHandler(true)
            }
        }
    }
    
    static func getCommentData(postId: String,completionHandler : @escaping ([CommentModel]) -> Void){
        var commentsArray : [CommentModel] = [CommentModel]()
        fireStoreObject.collection("posts").document(postId).collection("comments").addSnapshotListener{ (querySnapShot, error) in
            if error != nil {
                print(error!)
            }else {
                commentsArray.removeAll()
                for document in querySnapShot!.documents {
                    commentsArray.append(CommentModel(commentUserName: document.data()["commentUserName"] as! String, commentOfUser: document.data()["commentOfUser"] as! String))
                }
                completionHandler(commentsArray)
            }
        }
    }
}
