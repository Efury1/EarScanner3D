//
//  ForgotPassViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 22/8/21.
//

import SwiftUI
import Foundation
import UIKit
import MessageUI

class ForgotPassViewController: UIViewController {
    
    public static var activeTextField : UITextField? = nil
    @IBOutlet weak var verificationCodeInput: UITextField!
    @IBOutlet weak var Email: UITextField!
    struct MyVariables {
        static var email = "None"
        static var code = "None"
     
    }
    override func
    viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if (Email != nil){
        Email.delegate = self;
        }
        if (verificationCodeInput != nil){
            verificationCodeInput.delegate = self;
        }
        //Additional setup after loading view
        LoginViewController.previousController = LoginViewController.currentController
        LoginViewController.currentController = self

       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            if isBeingDismissed {
                LoginViewController.currentController = LoginViewController.previousController
            }
        }
    @IBAction func sendEmail(_ sender: UIButton) {
        

        print("Called")
        guard let email = Email.text else { return print("error") }
        MyVariables.email = email
        //Need to confirm email exisits
        //Hit the API with the email to check if
        //Email Exists
        
        let url = URL(string:
                        "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/checkemail")

        var request = URLRequest(url: url!) //make a request object with the url
        let rand = randomString(length: 6)
        let jsonbody = [  "Email": email, "Code": rand]  //attach the json body to he request. pass in the text inputs
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
            //if API returns false:
                //Alert "Email Doesn't Exist in System"
            if (APIResponse.contains("NoEmail")){
                 DispatchQueue.main.async {
                    print("alert")
                    let alert = UIAlertController(title: "Email Error", message: "Email is Not Registered to Database", preferredStyle: UIAlertController.Style.alert) //create alert
                        //I'm a pop up
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                    self.present(alert, animated: true, completion: nil)
                        //I end here
                        // show the alert
                    }
            }
            else if (APIResponse.contains("True")){
                //send the email
                MyVariables.code = rand;
                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                    let childViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "EnterCode")
                     self.addChild(childViewController)
                     self.view.addSubview(childViewController.view)
                     childViewController.didMove(toParent: self)
                    
                }
                
                
                
                
                
            }
            else if (APIResponse.contains("False")){
                print(APIResponse)
                DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: APIResponse, message: "Something Went Wrong", preferredStyle: UIAlertController.Style.alert) //create alert
                    //I'm a pop up
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil)
                    //I end here
                    // show the alert
                }
            }
            //if API Returns True:
                //generate six digit code
                //send code to an API that takes the code and email, and adds the code to the account with the email
                //Send Code to the Email
                //move to next page
            
    }
        dataTask.resume() //resume the datatask
    }
        
        
 
    
   
    
    @IBAction func CheckCode(_ sender: UIButton) {
        
        if (verificationCodeInput.text == MyVariables.code){
            
            let childViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "PasswordChange")
            self.addChild(childViewController)
            self.view.addSubview(childViewController.view)
            childViewController.didMove(toParent: self)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Verification Code is Wrong", preferredStyle: UIAlertController.Style.alert) //create alert
                                    //I'm a pop up
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil)
            //
        }
        //use email and code to hit an API
        //if API true move to next page
        //if not alert wrong code and go back to login page
        
        
//        let url = URL(string:
//                        "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/checkcode")
//
//        var request = URLRequest(url: url!) //make a request object with the url
//        let email = MyVariables.email
//        print("email = "+email)
//        guard let code = verificationCodeInput.text else { return print("error") }
//        print("code = "+code)
//
//        let jsonbody = [  "Email": email, "Code": code]  //attach the json body to he request. pass in the text inputs
//        do //making sure to convet it to json and attach it, testing if it breaks
//        {
//            let requestBody = try JSONSerialization.data(withJSONObject: jsonbody, options: .fragmentsAllowed)
//            request.httpBody = requestBody
//        }
//        catch
//        {
//            print("error creating request body")
//        }
//        request.httpMethod = "POST" //set the method to //POST
//        let session = URLSession.shared
//        var APIResponse = "False"
//
//        //make the request
//
//
//        let dataTask =  session.dataTask(with: request) { data, response, error in
//        //decode the request and print the result
//            //checks if response returned and if not checks internet
//            if (data != nil){
//                APIResponse = String(decoding: data!, as: UTF8.self)}
//            print("UserExist: ")
//            print(APIResponse)
//            //if API returns false:
//                //Alert "Email Doesn't Exist in System"
//            if (APIResponse.contains("False")){
//                 DispatchQueue.main.async {
//                    print("alert")
//                    let alert = UIAlertController(title: "Error", message: "Verification Code is Wrong", preferredStyle: UIAlertController.Style.alert) //create alert
//                        //I'm a pop up
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
//                    self.present(alert, animated: true, completion: nil)
//                        //I end here
//                        // show the alert
//                    }
//            }
//            else if (APIResponse.contains("True")){
//                //send the email
//                DispatchQueue.main.async {
////                    self.performSegue(withIdentifier: "loginSegue", sender: self)
//                    let childViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "PasswordChange")
//                     self.addChild(childViewController)
//                     self.view.addSubview(childViewController.view)
//                     childViewController.didMove(toParent: self)
//
//                }
//            }
//        }
//        dataTask.resume()
                
                
    }
    
    
    @IBOutlet weak var NewPassword: UITextField!
    
    @IBOutlet weak var NewPasswordConfirm: UITextField!
    
    
    @IBAction func SetPassword(_ sender: UIButton) {
        if (NewPassword.text == NewPasswordConfirm.text && NewPassword.text != "" && NewPassword.text != " "){
            let url = URL(string:
                            "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/changepassword")

            var request = URLRequest(url: url!) //make a request object with the url
           
            let jsonbody = [ "Email": MyVariables.email, "Password": cryto(password: NewPassword.text ?? "Somethings Wrong (forgot password)")] as [String : Any]  //attach the json body to he request. pass in the text inputs
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
            let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartMain")
           
            childViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(childViewController, animated: true, completion: nil)
       
        //if the passwords are the same hit the API to change the password where the email is this one
    }
    else{
        
        let alert = UIAlertController(title: "Error", message: "Passwords Dont Match or Are Invalid", preferredStyle: UIAlertController.Style.alert) //create alert
                                //I'm a pop up
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
            self.present(alert, animated: true, completion: nil)
        }
    
}
}
extension ForgotPassViewController : UITextFieldDelegate {
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
    print("hehe")
    LoginViewController.activeTextField = textField
  }
    
  // when user click 'done' or dismiss the keyboard
  func textFieldDidEndEditing(_ textField: UITextField) {
    LoginViewController.activeTextField = nil
  }
}
