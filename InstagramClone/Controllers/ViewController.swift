//
//  ViewController.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 03/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    var firebaseAuthObj : Auth?
    var firestoreObj : Firestore?
    var currUser : UserProfile?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firebaseAuthObj = Auth.auth()
        firestoreObj = Firestore.firestore()
    }
    
    
    
    
    //MARK: - Login Button
    @IBAction func loginButton(_ sender: UIButton) {
        ProgressHUD.show()
        loginUser()
    }
    
    //MARK: - Firestore and FireAuth Methods
    func loginUser(){
        firebaseAuthObj?.signIn(withEmail: userName.text!, password: password.text!, completion: { (user, error) in
            // ProgressHUD.dismiss()
            let userObj = user?.user
            if error != nil{
                print(error!)
            }else {
                self.checkUserExists { (boolValue) in
                    if boolValue {
                        UserDetails.setUserDetails(userProfile: self.currUser, name: self.name.text!) {
                            self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
                            ProgressHUD.dismiss()
                        }
                    }else {
                        self.storeUser(user: userObj!)
                    }
                }
            }
        })
    }
    
    func storeUser(user: User){
        self.firestoreObj?.collection("users").document((user.uid)).setData(["uid" :(user.uid),"emailId":(user.email)!,"name":name.text!],merge: true,completion: {error in
            if error != nil {
                print(error!)
            }else{
                UserDetails.setUserDetails(user: user, name: self.name.text!){
                    self.performSegue(withIdentifier: "goToHomeScreen", sender: self)
                    ProgressHUD.dismiss()
                }
                
            }
        })
    }
    
    
    func checkUserExists(completionHandler :@escaping  (Bool) -> Void){
        var userExists : Bool =  false
        self.firestoreObj?.collection("users").whereField("emailId", isEqualTo: userName.text!).getDocuments(completion: { (querySnapShot, error) in
            if error != nil {
                print(error!)
            }else {
                if let document = querySnapShot?.documents[0],(querySnapShot?.documents[0].exists)! {
                    userExists = true
                    self.currUser = UserProfile(data : (document.data()))!
                    print(self.currUser?.userProfileUrl! as Any)
                    print("User Exists 1")
                    completionHandler(userExists)
                }else {
                    print("User Does not Exists")
                    completionHandler(userExists)
                }
            }
        })
        
    }
    
}

