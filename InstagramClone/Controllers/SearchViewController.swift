//
//  SearchViewController.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 04/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//
import UIKit
import ProgressHUD
import FirebaseFirestore
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchUser: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    var userDataArr : [UserProfile] = [UserProfile]()
    var searchDataArr : [UserProfile] = [UserProfile]()
    var searching =  false
    let imageCommFuncs = ImageCommonFuncs.shared
    var selectedUser : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 83.0
        retrieveUsers()
        
    }
    
    
    
    
    
    
    //MARK: - Search Bar Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDataArr = userDataArr.filter({$0.userEmail.prefix(searchText.count) == searchText})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    
    
    //MARK: - Tableview Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchDataArr.count
        }else{
            return userDataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            if searching {
                cell.userEmail.text = searchDataArr[indexPath.row].userEmail
                setUserPhoto(indexPath: indexPath, arrayOfUsers: searchDataArr, cell: cell)
            }else{
                cell.userEmail.text = userDataArr[indexPath.row].userEmail
                setUserPhoto(indexPath: indexPath, arrayOfUsers: userDataArr, cell: cell)
            }
        
        return cell
    }
    
    func setUserPhoto(indexPath : IndexPath, arrayOfUsers : [UserProfile], cell : SearchTableViewCell){
        if arrayOfUsers[indexPath.row].userProfileUrl == nil {
            cell.userProfile.image = UIImage(systemName: "person.crop.circle.fill")
        }else {
            imageCommFuncs.loadImage(image: cell.userProfile, url: arrayOfUsers[indexPath.row].userProfileUrl!)
        }
         cell.userProfile.setRounded()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            selectedUser = searchDataArr[indexPath.row].userUid
            }else {
            selectedUser = userDataArr[indexPath.row].userUid
        }
        self.performSegue(withIdentifier: "SearchViewAccount", sender: self)
    }
    
    
    
    //MARK: - FireStore Recieve Methods
    func retrieveUsers(){
        ProgressHUD.show()
        FirestoreData.retrieveUsers { (userDataArr) in
            self.userDataArr = userDataArr
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    
    
    //MARK: - Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SearchViewAccount" {
            let destinationVC = segue.destination as! AccountViewController
            destinationVC.userUid = selectedUser
        }
    }
}

