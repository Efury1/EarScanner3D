//
//  MainViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 15/8/21.
//

import Foundation
import UIKit

class MainViewController: UINavigationController {

    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedin")
    }
    
    func handleSignOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
    }
}
