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


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
     /*
     ELiza: Need to add Terms and Condition solution
     
     */
    

    
    //Need to redo these after the storyboard has correct dimensions
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var retypeEmailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signup: UIButton!
    
    //delegate allows 
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
    }
    //create encyption key for passoword
    func keyAccount(_ password: String) -> SymmetricKey {
      // Create a SHA256 hash from the provided password
      let hash = SHA256.hash(data: password.data(using: .utf8)!)
      // Convert the SHA256 to a string. This will be a 64 byte string
      let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
      // Convert to 32 bytes
      let subString = String(hashString.prefix(32))
      // Convert the substring to data
      let keyData = subString.data(using: .utf8)!
     
      // Create the key use keyData as the seed
      return SymmetricKey(data: keyData)
    }
    
    func encryptCodableObject<T: Codable>(_ object: T, usingKey key: SymmetricKey) throws -> String {
      // Convert to JSON in a Data record
      let encoder = JSONEncoder()
      let userData = try encoder.encode(object)
     
      // Encrypt the userData
      let encryptedData = try ChaChaPoly.seal(userData, using: key)
     
      // Convert the encryptedData to a base64 string which is the
      // format that it can be transported in
      return encryptedData.combined.base64EncodedString()
    }
    
 
//Buttons are connected
@IBAction func signup(_ sender: Any) {
        //create URL, will need URL
        let url = URL(string: "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/Login") //creating URL object
        let session = URLSession.shared //Session object
        //create the URLRequest object using the url object
        var request = URLRequest(url: url!)
        let email = emailTextField.text!
        let password = passwordTextField
        let jsonbody = [  "Email": email, "Password": password!] as [String : Any]
        
        
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonbody, options: .fragmentsAllowed)
            request.httpBody = requestBody
        } catch let error {
            print(error.localizedDescription)
        }
    

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

