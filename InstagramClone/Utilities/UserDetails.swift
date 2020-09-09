//
//  UserDetails.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 14/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserDetails {
    public static let sharedUserDetailsInstance = UserDetails()
    private init(){
    }
    
    public func getUserUid() ->  String {
        return UserDefaults.standard.string(forKey: "UserUid")!
    }
    
    public func getUserPhoto() -> String {
        return UserDefaults.standard.string(forKey: "UserPhoto")!
    }
    
    public func getUserName() -> String {
        return UserDefaults.standard.string(forKey: "UserName")!
    }
    
    public func getUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "UserLoggedIn")
    }
    
    public static func setUserDetails(user : User? = nil,userProfile : UserProfile? = nil,name : String, completionHandler : () -> Void){
        UserDefaults.standard.set(user?.email ?? userProfile?.userEmail , forKey: "UserEmail")
        UserDefaults.standard.set(user?.uid ?? userProfile?.userUid, forKey: "UserUid")
        UserDefaults.standard.set(name, forKey: "UserName")
        UserDefaults.standard.set(userProfile?.userProfileUrl ?? "nil", forKey: "UserPhoto")
        UserDefaults.standard.set(true, forKey: "UserLoggedIn")
       completionHandler()
    }
    
    public static func removeUserDefaults(completionHandler : () -> Void){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        completionHandler()
    }
}
