//
//  SignupViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 3/8/21.
//

import Foundation
import UIKit



class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var retypeEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerTextField: UIButton!
    
    
    /*Adding a Json element ot a Json file usong the data given by a Post Request. How to add id to data?*/
    
    func saveCredentials() {
        
        let email:String = emailTextField.text!
        let password:String = passwordTextField.text!
        
        let url = URL(string:  "https://r316dbbv9l.execute-api.ap-southeast-2.amazonaws.com/Version2-POST/login")
        var request = URLRequest(url: url!) //make a request object with the url
        let jsonbody = [  "Email": email, "Password": password]  //attach the json body to he request. pass in the text inputs
        
        let file = "register.json"  //create file
        //Need get request
        //let savingCredentials = request.get("https://r316dbbv9l.execute-api.ap-southeast-2.amazonaws.com/Version2-POST/login")
        //let data = savingCredentials.json()
        
        
        }
}


