//
//  LoginViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 3/8/21.
//

import Foundation

import UIKit

class LoginViewController: UIViewController {
    
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
        //set the url of the api
        let url = URL(string:  "https://r316dbbv9l.execute-api.ap-southeast-2.amazonaws.com/Version2-POST/login?fbclid=IwAR3BVYlKy_6Wza495RLvXkbBLzdP058VtwSw4qpNppmdHwVA5Bgf49rgTUM")
        //make a request object with the url
        var request = URLRequest(url: url!)
        //attach the json body to he request
        let jsonbody = [  "UserName": "James", "Password": "Noye"]
        //making sure to convet it to json and attach it, testing if it breaks
        do { let requestBody = try JSONSerialization.data(withJSONObject: jsonbody, options: .fragmentsAllowed)
            request.httpBody = requestBody
        }
        catch {
            print("error creating request body")
        }
        //set the method to POST
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        //make the request
        let dataTask = session.dataTask(with: request) { data, response, error in
        //decode the request and print the result
            let UserExists = String(decoding: data!, as: UTF8.self)
            print(UserExists) //returns true or false boolean
            

        }
        //resume the datatask
        dataTask.resume()
        
        
    }
    
    



            
          
            
     
    
        }
    




