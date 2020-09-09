//
//  AccountViewController.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 14/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import UIKit
import ProgressHUD

class AccountViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , ImagePickerDelegate{
    
    @IBOutlet weak var accountProfileImage: UIImageView!
    @IBOutlet weak var postsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var accountUserName: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var userData : UserProfile?
    var postsArr : [HomePosts] = [HomePosts]()
    let imageCommInstance = ImageCommonFuncs.shared
    var imagePicker: ImagePicker!
    var userUid : String?
    //CollectionView Variables
    let inset: CGFloat = 2
    let minimumLineSpacing: CGFloat = 2
    let minimumInteritemSpacing: CGFloat = 2
    let cellsPerRow = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followButton.isHidden = true
        let nib = UINib(nibName: "ImgAccountCollectionViewCell", bundle: nil)
        imageCollectionView.register(nib, forCellWithReuseIdentifier: "ImgAccountCollectionViewCell")
        imageCollectionView.contentInsetAdjustmentBehavior = .always
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        if userUid != nil {
            followButton.isHidden = false
            followButton.setBorder()
        }
        
        setGestureForImageView()
        getData()
        accountProfileImage.setRounded()
    }
    
    
    //MARK: - CollectionView Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ImgAccountCollectionViewCell", for: indexPath) as! ImgAccountCollectionViewCell
        imageCommInstance.loadImage(image: cell.imgCollection, url: postsArr[indexPath.row].postUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    
    
    //4 + 0 +0
    //MARK: - FireStore Methods
    func getData(){
        ProgressHUD.show()
        FirestoreData.retrieveSingleUser(userUid: userUid != nil ? userUid! : UserDetails.sharedUserDetailsInstance.getUserUid()) { (userData, postsArr) in
            self.userData = userData
            self.postsArr = postsArr
            self.setUserData()
            self.imageCollectionView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    func updateProfileUrl(url : String){
        
    }
    
    //MARK: - Set Data
    func setUserData(){
        if userData!.userProfileUrl == nil {
            accountProfileImage.image = UIImage(systemName: "person.crop.circle.fill")
        }else{
            imageCommInstance.loadImage(image: accountProfileImage, url: userData!.userProfileUrl!)
        }
        
        accountUserName.text = userData!.userName
        postsCount.text = "\(postsArr.count)"
        followersCount.text = "\(userData!.followersCount ?? 0)"
        followingCount.text = "\(userData!.followingCount ?? 0)"
        
        if userData!.followers?.contains(UserDetails.sharedUserDetailsInstance.getUserUid()) ?? false {
            followButton.setTitle("unfollow", for: .normal)
        }else {
            followButton.setTitle("follow", for: .normal)
        }
    }
    
    //MARK: - ImagePicker Methods
    func setGestureForImageView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddPostViewController.tappedMe))
        accountProfileImage.addGestureRecognizer(tap)
        accountProfileImage.isUserInteractionEnabled = true
    }
    
    @objc func tappedMe()
    {
        print("Tapped on Image")
        self.imagePicker.present(from: accountProfileImage)
    }
    func didSelect(image: UIImage?) {
        ProgressHUD.show()
        FirestoreData.uploadProfilePic(image: image!, userUid: userData!.userUid, imageName: userData!.userUid+"profile.png", whichCollection: "ProfilePicture"){(urlString) in
            ImageCommonFuncs.shared.loadImage(image: self.accountProfileImage, url: urlString)
            ProgressHUD.dismiss()
        }
    }
    
    
    
    
    //MARK: - UI Element Methods
    @IBAction func followButton(_ sender: Any) {
        if followButton.title(for: .normal) == "follow"{
            followButton.setTitle("unfollow", for: .normal)
            ProgressHUD.show()
            FirestoreData.addFollowData(otherUserUid: userUid!, currentUserUid: UserDetails.sharedUserDetailsInstance.getUserUid()) { (boolvalue) in
                if boolvalue{
                    ProgressHUD.dismiss()
                }
            }
        }else{
            followButton.setTitle("unfollow", for: .normal)
            ProgressHUD.show()
            FirestoreData.removeFollowData(otherUserUid: userUid!, currentUserUid: UserDetails.sharedUserDetailsInstance.getUserUid()) { (boolvalue) in
                if boolvalue{
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
}
