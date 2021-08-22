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

struct Response: Codable {
    let results: MyResults
    let status: String
}

struct MyResults: Codable {
    let email: String
    let password: String
}


//It's not getting response therefore code is printing something went wrong
private func getData(from url: String) {
    let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
        
        guard let data = data, error == nil else {
            //data back if nil
            print("Something went wrong")
            return
        }
        
        //have data
        var result: Response?
        do {
            //map data to Response
            result = try JSONDecoder().decode(Response.self, from: data)
        } catch {
            print("failed to convert \(error.localizedDescription)")
        }
        guard let json = result else {
            return
        }
        print(json.status)
        print(json.results)
        print(json.results.email)
    })
    
    task.resume()
    
}
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
        //let url = "earscannerdb.ckczsnjdfawk.ap-southeast-2.rds.amazonaws.com"
        //getData(from: url)
    }
    
    
  
    @IBAction func signup(_ sender: Any)
    {

        var inputtedPassword: String? { // optional, remember textfield.text can return nil
            return passwordTextField.text
        }
        
        var inputtedEmail: String? { // optional, remember textfield.text can return nil
            return emailTextField.text
        }
        
        //let inputtedPassword = passwordTextField.text
        //let inputtedEmail = emailTextField.text
        
        if((inputtedPassword == "") || inputtedEmail == "") {
            print("Please ensure all fields are typed in")
        }
        else {
            let url = "earscannerdb.ckczsnjdfawk.ap-southeast-2.rds.amazonaws.com"
            getData(from: url)
        }
            
    }
}
       

    

