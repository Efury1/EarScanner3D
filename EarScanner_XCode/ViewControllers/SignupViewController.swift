//
//  SignupViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 3/8/21.
//

import Foundation
import UIKit;

class SignUpViewController:
    UIViewController {

    @IBOutlet weak var
        NameTextField:
            UITextField!

    @IBOutlet weak var
        LastNameTextField:
            UITextField!
    
    @IBOutlet weak var
        EmailTextField:
            UITextField!
    
    @IBOutlet weak var
        PasswordTextField:
            UITextField!
    
    
    @IBOutlet weak var
        ConfirmPasswordTextField:
            UITextField!
    
    @IBOutlet weak var
        SignupButton:
            UIButton!
    
    
    @IBOutlet weak var
        ErrorLabel:
            UIButton!
    
    //functions 
    
    @IBAction func
        signUpTapped(_
        sender: Any) {
    }
}
