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
    // when user select a textfield, this method will be called
    public static var activeTextField : UITextField? = nil
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      // set the activeTextField to the selected textfield
      print("hehe")
     LoginViewController.activeTextField = textField
    }
      
    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
      LoginViewController.activeTextField = nil
    }
    //Need to redo these after the storyboard has correct dimensions
    @IBOutlet weak var LastNameField: UITextField!
    @IBOutlet weak var FirstNameField: UITextField!
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
        self.hideKeyboardWhenTappedAround()
        LoginViewController.previousController = LoginViewController.currentController;
        
        LoginViewController.currentController = self
        
        emailTextField.delegate = self;
        passwordTextField.delegate = self;
        LastNameField.delegate = self;
        retypeEmailTextField.delegate = self;
        FirstNameField.delegate = self;
        
      
    }

override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            LoginViewController.currentController = LoginViewController.previousController
        }
    }
 
//Buttons are connected
@IBAction func signup(_ sender: Any) {
    print("heh")
        //create URL, will need URL
        let url = URL(string: "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/Register") //creating URL object
        let session = URLSession.shared //Session object
        //create the URLRequest object using the url object
        var request = URLRequest(url: url!)
    request.httpMethod = "POST"

    let email = emailTextField.text!
    let password = passwordTextField.text!
    let FirstName = FirstNameField.text!
    let LastName = LastNameField.text!
    let salt = randomString(length: 8)
    if((email == "") || password == "" || FirstName == "" || LastName == "") {
                print("Please ensure all fields are typed in")
                DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: "Error", message: "Please make sure you fill in all fields", preferredStyle: UIAlertController.Style.alert) //create alert
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil) // show the alert
                }
        
            }
            else {
                let jsonbody = [  "Email": email, "Password": cryto(password: password), "FirstName": cryto(password: FirstName), "LastName": cryto(password: LastName), "Salt": cryto(password: salt)] as [String : Any]
            
            
            do {

                let requestBody = try JSONSerialization.data(withJSONObject: jsonbody, options: .fragmentsAllowed)
                request.httpBody = requestBody
            } catch let error {
                
                print(error.localizedDescription)
            }
        

            //Create dataTask using the session object to send to server
        var UserExists = "False"
        
        let dataTask =  session.dataTask(with: request) { data, response, error in
            print("heh2")
        //decode the request and print the result
            //checks if response returned and if not checks internet
            if (data != nil){
        UserExists = String(decoding: data!, as: UTF8.self)
            /// USEREXISTS
            
            print(UserExists)
            
            if (UserExists.contains("True")){
                //Implement autologin
                self.userDefaults.setValue(true, forKey: "UserExists")
                DispatchQueue.main.async {
                    let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartMain")
                   
                    childViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                    self.present(childViewController, animated: true, completion: nil)

                  
                }
                
                
                return
            }
            else if (UserExists.contains("False"))
            {
                DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: "Error", message: "Something Went Wrong", preferredStyle: UIAlertController.Style.alert) //create alert
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil) // show the alert
                }
                
                
                return
            }
            }
            else{
                print("error with connection")
                DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: "Error", message: "Please Check Internet Connection", preferredStyle: UIAlertController.Style.alert) //create alert
                    //I'm a pop up
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil)
                    //I end here
                    // show the alert
                }
            }
        }
            dataTask.resume()
        }
    }
}

