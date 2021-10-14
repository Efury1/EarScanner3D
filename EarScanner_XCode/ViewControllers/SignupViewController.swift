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
    public static var email: String = ""
    public static var password: String = ""
    public static var FirstName: String = ""
    public static var LastName: String = ""
    public static var salt: String = ""
    
    @IBOutlet weak var termsAccepted: UISwitch!
    
    var switchState:Bool {
        return termsAccepted.isOn
    }
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
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var termsConditions: UIButton!
    
    
    //delegate allows text field to be a string
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        LoginViewController.previousController = LoginViewController.currentController;
        
        LoginViewController.currentController = self
        
        emailTextField.delegate = self;
        passwordTextField.delegate = self; //password
        LastNameField.delegate = self;
        passwordTextField.delegate = self; //actual password
        confirmPasswordTextField.delegate = self; //actual password
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
        
        
        SignUpViewController.email = emailTextField.text!
        SignUpViewController.password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        SignUpViewController.FirstName = FirstNameField.text!
        SignUpViewController.LastName = LastNameField.text!
        SignUpViewController.salt = randomString(length: 8)
        
        if (confirmPassword != SignUpViewController.password){
            DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: "Error", message: "The passwords do not match", preferredStyle: UIAlertController.Style.alert) //create alert
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil) // show the alert
            }
        }
        else if (switchState != true){
            DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: "Terms & Conditions", message: "Please accept the Terms & Conditions", preferredStyle: UIAlertController.Style.alert) //create alert
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil) // show the alert
            }
        }
        else if((SignUpViewController.email == "") || SignUpViewController.password == "" || SignUpViewController.FirstName == "" || SignUpViewController.LastName == "") {
            print("Please fill in all fields")
            DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: "Empty Fields", message: "Please fill in all fields", preferredStyle: UIAlertController.Style.alert) //create alert
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil) // show the alert
            }
            
        }
        else if (!isValidEmail(testStr: SignUpViewController.email)){
            //
            DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: "Invalid Email", message: "This email address is not valid", preferredStyle: UIAlertController.Style.alert) //create alert
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil) // show the alert
            }
        }
        else if (!isValidPassword(testStr: SignUpViewController.password)){
            //
            DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: "Invalid Password", message: "Password must contain at least 8 characters and 1 number.", preferredStyle: UIAlertController.Style.alert) //create alert
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil) // show the alert
            }
        }
        
        else {
            signupUser(email: SignUpViewController.email, password: SignUpViewController.password, FirstName: SignUpViewController.FirstName, LastName: SignUpViewController.LastName, salt: SignUpViewController.salt)
            
        }
        
        
        
    }
    public func signupUser(email: String, password: String, FirstName: String, LastName: String, salt: String){
        let url = URL(string: "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/Register") //creating URL object
        let session = URLSession.shared //Session object
        //create the URLRequest object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let jsonbody = [  "Email": email, "Password": cryto(password: password), "FirstName": FirstName, "LastName": LastName, "Salt": cryto(password: salt)] as [String : Any]
        
        
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
                        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert) //create alert
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                        self.present(alert, animated: true, completion: nil) // show the alert
                    }
                    
                    
                    return
                }
                else if (UserExists.contains("Email Already Exists"))
                {
                    DispatchQueue.main.async {
                        print("alert")
                        let alert = UIAlertController(title: "Email Already Exists", message: "This email has already been registered", preferredStyle: UIAlertController.Style.alert) //create alert
                        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                        self.present(alert, animated: true, completion: nil) // show the alert
                    }
                    
                    
                    return
                }
            }
            else{
                print("error with connection")
                DispatchQueue.main.async {
                    print("alert")
                    let alert = UIAlertController(title: "Error", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert) //create alert
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
    public func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    public func isValidPassword(testStr:String) -> Bool {
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passTest = NSPredicate(format:"SELF MATCHES[c] %@", passRegEx)
        return passTest.evaluate(with: testStr)
    }
    
}

