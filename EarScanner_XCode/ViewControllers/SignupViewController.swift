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
    
    //Need to redo these after the storyboard has correct dimensions
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var retypeEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerTextField: UIButton!
    
    
    //switch button. Still need to drag it in
    /*@IBOutlet func switchPressed(   sender: UISwitch) {
        if switch.isOn() {
            label.text = "Switch is on"
        switch.SetOn(false, animated: true)
        } else {
            label.text = "Switch is on"
            switch.setOn(true, animated: true)
        }
    }*/
     
    //Eliza: Need to change registerText to button
    //Need to check whether text fields are written
    //Password needs to specify the expectations
    //Make sure email has a @
    //Check if user exsists
    
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

//Codeable is alias for two other modules Encodable and Decodable
struct Users: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    
}


/*class SignUpViewController: UIViewController {
let encoder = JSONEncoder()
let data = try encoder.encode(Users)
let string = String(data: data, encoding: .utf8)!
    
    //if this enum exists, we be used for coding and encoding
    func emumCodingKeys() -> String;, CodingKey {
        case firstName,  lastName, email, password
        
    }
 }*/
