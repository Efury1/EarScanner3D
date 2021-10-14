//
//  LoginViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 3/8/21.
//

import Foundation
import CryptoSwift
import UIKit
//import KeychainAccess
import CryptoKit

class LoginViewController: UIViewController {
    
    var userDefaults = UserDefaults.standard
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var rememberMe: UISwitch!

    public static var activeTextField : UITextField? = nil
    public static var currentController : UIViewController? = nil
    public static var previousController : UIViewController? = nil
    public static var whichView: String = ""
    
    public static var Email = "";
   /*
     Store a session key, which is generated by the server side. M
     Make 16 byte long.
     1. Obtaining a random session key from server
     2. Store it on the user device
     3. Send back to sevrer when needed.
     */
    
    
   
    
    struct MyVariables {
        static var UserExists = "None"
        static var dataTaskFinished = false
    }
    
//    @IBAction func GoToSignUp(_ sender: UIButton) {
//        let childViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
//         self.addChild(childViewController)
//         self.view.addSubview(childViewController.view)
//         childViewController.didMove(toParent: self)
//        
//    }
//    
    override func
    viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        PasswordField.delegate = self;
        EmailField.delegate = self;
        self.view.frame.origin.y = 0
        LoginViewController.currentController = self
        //Additional setup after loading view

       
    }
    
    

    


    //Handing Login button
    @IBAction func
    loginTapped(_ sender: Any) {
        LoginViewController.Email = EmailField.text ?? "I dont know"
        print(cryto(password: "qw"))
//    saves the text inputs to variables
     guard
        let email = EmailField.text,
        
        let password = PasswordField.text
     else {return}
        
        //set the url of the api
        print("hehe: "+email)
        print(cryto(password: password))
        let url = URL(string:  "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/Login")
        var request = URLRequest(url: url!) //make a request object with the url
        let jsonbody = [  "Email": email, "Password": cryto(password: password)]  //attach the json body to he request. pass in the text inputs
        do //making sure to convet it to json and attach it, testing if it breaks
        {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonbody, options: .fragmentsAllowed)
            request.httpBody = requestBody
        }
        catch
        {
            print("error creating request body")
        }
        
        
    
        request.httpMethod = "POST" //set the method to POST
        let session = URLSession.shared
        var UserExists = "False"
        
        //make the request
        MyVariables.dataTaskFinished = false
        
        let dataTask =  session.dataTask(with: request) { data, response, error in
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
//                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                    let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartMain")
                     self.addChild(childViewController)
                     self.view.addSubview(childViewController.view)
                     childViewController.didMove(toParent: self)
                    
                }
                MyVariables.UserExists = "True"
                MyVariables.dataTaskFinished = true
                return
            }
            else if (UserExists.contains("False"))
            {
                DispatchQueue.main.async {
                print("alert")
                let alert = UIAlertController(title: "Login Error", message: "Incorrect email or password", preferredStyle: UIAlertController.Style.alert) //create alert
                alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                self.present(alert, animated: true, completion: nil) // show the alert
                }
                MyVariables.UserExists = "False"
                MyVariables.dataTaskFinished = true
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
            
             //returns true or false string
            
        }
        
        
        
        dataTask.resume() //resume the datatask
        var waiting = 0
//        while (MyVariables.dataTaskFinished == false && waiting < 1000){
//            print("waiting")
//            waiting += 1
//
//        }
//        sleep(2)
        //if the result is yet to come in wait a second, then check again
        //do this up to 4 times (4 seconds)
//        while(MyVariables.UserExists != "True" && MyVariables.UserExists != "False" && waiting < 4){
//            print(waiting)
//            sleep(1)
//            waiting += 1;
//        }
//
//        if (MyVariables.UserExists == "True"){
//            let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartMain")
//            self.addChild(childViewController)
//            self.view.addSubview(childViewController.view)
//            childViewController.didMove(toParent: self)
//        }
//        else if (MyVariables.UserExists == "False"){
//            //Alert if password or email is wrong
//            print("alert")
//            let alert = UIAlertController(title: "Error", message: "Wrong password or email", preferredStyle: UIAlertController.Style.alert) //create alert
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
//            self.present(alert, animated: true, completion: nil) // show the alert
//            
//        }
//        else{ //if no response say so
//            let alert = UIAlertController(title: "Error", message: "Connection Timed Out", preferredStyle: UIAlertController.Style.alert) //create alert
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
//            self.present(alert, animated: true, completion: nil) // show the alert
//        }
    }
}

//extension LoginViewController : UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//
//        return true
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField){
//    // set the activeTextField to the selected textfield
//    print("heheheh")
//    extensionsVariable.activeTextField = textField
//  }
//    
//  // when user click 'done' or dismiss the keyboard
//  func textFieldDidEndEditing(_ textField: UITextField)
//  {
//    extensionsVariable.activeTextField = nil
//  }
//
//
//}
//
public func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
public func cryto(password: String) -> String{
 //let encryptedBytes = try AES(key: [1,2,3,...,32], blockMode: CBC(iv: [1,2,3,...,16]), padding: .pkcs7)
    
    do {
        print("Password: "+password)
        let password: [UInt8] = Array(password.utf8)
        
        /* Generate a key from a `password`. Optional if you already have a key */
        let key = Array("-JaNdRgUkXp2s5u8x/A?D(G+KbPeShVm".utf8)
        /* Generate random IV value. IV is public value. Either need to generate, or get it from elsewhere */
        let iv = Array("53827h0qwercgvyq".utf8)
        /* AES cryptor instance */
        let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
        /* Encrypt Data */
        let inputData = Data(password)
        let encryptedBytes = try aes.encrypt(inputData.bytes)
        let encryptedData = Data(encryptedBytes)
        let encryptedString = encryptedBytes.toBase64()
        print("encryption")
        print(encryptedString)
        
        return encryptedString
       
    } catch {
        print(error)
    }
   return "Failed"

}


public func hashco(password: String, salt: String) -> String{
 //let encryptedBytes = try AES(key: [1,2,3,...,32], blockMode: CBC(iv: [1,2,3,...,16]), padding: .pkcs7)
    

        
        let inputString = password+salt
        let inputData = Data(inputString.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
   print("hash"+hashString)
   return hashString
}

            
     
    
        
extension LoginViewController : UITextFieldDelegate {
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



