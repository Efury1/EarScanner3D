//
//  ChangeProfile.swift
//  EarScanner_XCode
//
//  Created by James Noye on 24/9/21.
//

import Foundation
import SwiftUI

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var OldPassword: UITextField!
    
    @IBOutlet weak var NewPassword: UITextField!
    
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    @IBAction func ChangePasswordProfile(_ sender: UIButton) {
        
        let OldPasswordText = OldPassword.text;
        let NewPasswordText = NewPassword.text;
        let ConfirmPasswordText = ConfirmPassword.text;
        
        if (NewPasswordText == ConfirmPasswordText && NewPasswordText != "" && NewPasswordText != " "){
            let url = URL(string:
                            "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/changepasswordprofile")

            var request = URLRequest(url: url!) //make a request object with the url
           
            let jsonbody = [ "NewPassword": NewPasswordText!, "OldPassword": cryto(password: OldPasswordText!), "Email": LoginViewController.Email] //attach the json body to he request. pass in the text inputs
            print("testing password", NewPasswordText!, OldPasswordText!, LoginViewController.Email)
            do //making sure to convet it to json and attach it, testing if it breaks
            {
                let requestBody = try JSONSerialization.data(withJSONObject: jsonbody, options: .fragmentsAllowed)
                request.httpBody = requestBody
            }
            catch
            {
                print("error creating request body")
            }
            request.httpMethod = "POST" //set the method to //POST
            let session = URLSession.shared
            var APIResponse = "False"
            
            //make the request

            
            let dataTask =  session.dataTask(with: request) { data, response, error in
            //decode the request and print the result
                //checks if response returned and if not checks internet
                if (data != nil){
                    APIResponse = String(decoding: data!, as: UTF8.self)}
                print("UserExist: ")
                print(APIResponse)
        }
            dataTask.resume()
            if (APIResponse == "True"){
            let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartMain")
           
            childViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(childViewController, animated: true, completion: nil)
       
        //if the passwords are the same hit the API to change the password where the email is this one
            }
            else if (APIResponse == "False"){
                let alert = UIAlertController(title: "Incorrect Password", message: "The current password is incorrect", preferredStyle: UIAlertController.Style.alert) //create alert
                                        //I'm a pop up
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                    self.present(alert, animated: true, completion: nil)
            }
    }
    else{
        
        let alert = UIAlertController(title: "Invalid Password", message: "The passwords do not match or are invalid. Passwords must contain at least 8 characters and 1 number.", preferredStyle: UIAlertController.Style.alert) //create alert
                                //I'm a pop up
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
