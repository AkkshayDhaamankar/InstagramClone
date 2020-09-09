//
//  AddPostViewController.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 06/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import ProgressHUD
class AddPostViewController : UIViewController, ImagePickerDelegate {
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postTitle: UITextField!
    
    @IBOutlet weak var postDescription: UITextField!
    
    var imagePicker: ImagePicker!
    let storage = Storage.storage()
    var storageRef : StorageReference?
    var firestoreObj : Firestore?
    let userDetails = UserDetails.sharedUserDetailsInstance
    var userUid : String?
    var userPhoto : String?
    var userName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userUid = userDetails.getUserUid()
        userName = userDetails.getUserName()
        userPhoto = userDetails.getUserPhoto()
        postImage.image = UIImage(systemName: "doc.fill")
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        storageRef = storage.reference()
        firestoreObj = Firestore.firestore()
        setGestureForImageView()
    }
    
    
    //MARK: - Submit Post To FirebaseStorage Methods And FireStore
    @IBAction func postSubmit(_ sender: UIButton) {
        if postImage.image == UIImage(systemName: "doc.fill"){
            print("Please enter Image")
            return
        }
        uploadImage(image : postImage.image!)
    }
    
    
    func uploadImage(image : UIImage){
        ProgressHUD.show()
        let imageRef = storageRef?.child(userUid!+"/"+userUid!+"-"+getCurrentTimeStamp()+"postImage.png")
        imageRef!.putData((image.pngData())!, metadata: nil) { (metadata, error) in
            if metadata == nil {
                // Uh-oh, an error occurred!
                return
            }
            // You can also access to download URL after upload.
            imageRef!.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
            self.saveImageUrlAndData(url: downloadURL.absoluteString)
            }
        }
    }
    
    
    func saveImageUrlAndData(url:String){
        let ref = self.firestoreObj?.collection("posts").document();
        ref!.setData(["postId":ref!.documentID ,"uid" :userUid!,"url":url,"title":postTitle.text?.isEmpty ?? true ? "#InstagramCloneTitle" : postTitle.text!,"description": postDescription.text?.isEmpty ?? true ? "#InstagramCloneDescription" : postDescription.text!,"time":getCurrentTimeStamp(),"UserPhoto":userPhoto!,"UserName":userName!],completion: {error in
            if error != nil {
                print(error!)
            }else{
                self.postDescription.text = ""
                self.postTitle.text = ""
                self.postImage.image = UIImage(systemName: "doc.fill")
                ProgressHUD.dismiss()
            }
        })
    }
    
    //MARK: - ImageView Methods
    
    func setGestureForImageView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddPostViewController.tappedMe))
        postImage.addGestureRecognizer(tap)
        postImage.isUserInteractionEnabled = true
    }
    
    @objc func tappedMe()
    {
        print("Tapped on Image")
        self.imagePicker.present(from: postImage)
    }
    func didSelect(image: UIImage?) {
        self.postImage.image = image
    }
    
    
    //MARK: - Current Date Methods
    func getCurrentTimeStamp() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy-HH_mm_ss"
        let dateString = dateFormatter.string(from: date)
        return String(dateString)
    }
    
    
    
}
