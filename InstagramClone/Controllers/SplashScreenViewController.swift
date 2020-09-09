//
//  SplashScreenViewController.swift
//  InstagramClone
//
//  Created by Akshay Dhamankar on 05/07/20.
//  Copyright © 2020 Akshay Dhamankar. All rights reserved.
//
import UIKit

class SplashScreenViewController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDetails.sharedUserDetailsInstance.getUserLoggedIn() {
            self.navigate(identifier: "goToHomeScreenSplash")
        }else {
            self.navigate(identifier: "goToLoginScreen")
        }
    }
    
    
    //MARK: - Segue Method
    func navigate(identifier : String){
        DispatchQueue.main.asyncAfter(deadline:.now() + 2.0, execute: {
            self.performSegue(withIdentifier:identifier,sender: self)
        })
    }
}
