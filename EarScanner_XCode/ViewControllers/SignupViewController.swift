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



class SignUpViewController: UIViewController {
    
    /*
     ELiza: Need to add Terms and Condition solution
     
     */
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var retypeEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerTextField: UIButton!
     
    //Eliza: Need to change registerText to button
    @IBAction func submitAction(sender: UIButton) {
        //create URL, will need URL
        let url = URL(string: "www.example.com") //creating URL object
        let session = URLSession.shared //Session object
        //create the URLRequest object using the url object
        var request = URLRequest(url: url!)
        let email = emailTextField
        let password = passwordTextField
        let jsonbody = [  "Email": email, "Password": password]
        
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonbody, options: .fragmentsAllowed)
            request.httpBody = requestBody
        } catch let error {
            print(error.localizedDescription)
        }
    
        //May had to do request.addValue()
        
        //Create dataTask using the session object to send to server
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            do { //Json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}

