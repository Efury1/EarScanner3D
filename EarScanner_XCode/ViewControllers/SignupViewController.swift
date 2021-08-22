//
//  SignupViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 3/8/21.
//
//  Eliza: Have worked on code to send user details to awss

import Foundation
import UIKit
import CoreData
import CryptoKit



/*
 * James, Not sure how to implement the encoding functions with the other code. Eliza*/
class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    //Need to redo these after the storyboard has correct dimensions
    var userDefaults = UserDefaults.standard
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var retypeEmailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBOutlet weak var termsConditions: UIButton!
    
    @IBAction func termsConditions(_ sender: Any) {
      //have some kind of scrolled pop up
    }
    //delegate allows text field to be a string
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
  
    @IBAction func signup(_ sender: Any)
    {
        let inputtedPassword = passwordTextField.text
        let inputtedEmail = emailTextField.text
        
        if((inputtedPassword == "") || inputtedEmail == "") {
            print("Please ensure all fields are typed in")
        }
        else {
            // prepare json data
            let json = [  "InputtedEmail": inputtedEmail, "InputtedPassword": inputtedPassword]

            let jsonData = try? JSONSerialization.data(withJSONObject: json)

            // create post request
            let url = URL(string: "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/Login")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            // insert json data to the request
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }

            task.resume()
        }
            
    }
}
       

    

