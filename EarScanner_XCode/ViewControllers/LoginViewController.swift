//
//  LoginViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 3/8/21.
//

import Foundation

import UIKit

class LoginViewController:
    UIViewController {
    
    @IBOutlet weak var
        emailLoginTextField:
            UITextField!
    
    
    @IBOutlet weak var
        passwordLoginTextField:
            UITextField!
    
    @IBOutlet weak var
        loginButton:
            UIButton!
    
    override func
    viewDidLoad() {
        super.viewDidLoad()
        //Additional setup after loading view
    }
    
    //Handing Login button
    @IBAction func
    loginTapped(_ sender:
                    Any) {
    }
}
