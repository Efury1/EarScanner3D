//
//  LoginViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 3/8/21.
//

import Foundation

import UIKit

class LoginViewController: UIViewController {
    
    var userDefaults = UserDefaults.standard
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var rememberMe: UISwitch!
    
    @IBAction func rememberMe(_ sender: Any) {
        //Turn on and off
        //Save in userDeautls
        if ((sender as AnyObject).isOn == true) {
            print("Is on")
            
        } else {
            print("Is off")
            
        }
    }
    
    struct MyVariables {
        static var UserExists = "None"
        static var dataTaskFinished = false
    }
    
    override func
    viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //Additional setup after loading view
    }
    
    
    @IBAction func Done(_ sender: UITextField) { //gets the text inputs
        sender.resignFirstResponder()
    }
    
    @IBAction func DonePassword(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    

    //Handing Login button
    @IBAction func
    loginTapped(_ sender: Any) {
       print("wtf")
//    saves the text inputs to variables
     guard
        let email = EmailField.text,
        let password = PasswordField.text
     else {return}
        
        //set the url of the api
        
        let url = URL(string:  "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/Login")
        var request = URLRequest(url: url!) //make a request object with the url
        let jsonbody = [  "Email": email, "Password": password]  //attach the json body to he request. pass in the text inputs
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
                let alert = UIAlertController(title: "Error", message: "Wrong password or email", preferredStyle: UIAlertController.Style.alert) //create alert
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
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
                let alert = UIAlertController(title: "Error", message: "Please Check Internet Connection", preferredStyle: UIAlertController.Style.alert) //create alert
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
        while(MyVariables.UserExists != "True" && MyVariables.UserExists != "False" && waiting < 4){
            print(waiting)
            sleep(1)
            waiting += 1;
        }
        
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

extension LoginViewController : UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
    
    



            
          
            
     
    
        




