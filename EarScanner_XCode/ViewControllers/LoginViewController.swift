//
//  LoginViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 3/8/21.
//

import Foundation

import UIKit

class LoginViewController: UIViewController {
    
 
    

    @IBOutlet weak var mainTitle: UILabel!
    
    struct MyVariables {
        static var UserExists = "False"
        static var dataTaskFinished = false
    }
    @IBOutlet weak var
        loginButton:
            UIButton!
    
    override func
    viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //Additional setup after loading view
    }
    //gets the text inputs
    
    @IBAction func Done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func DonePassword(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBOutlet weak var EmailField: UITextField!
    
    @IBOutlet weak var PasswordField: UITextField!
    
    

    //Handing Login button
    @IBAction func
    loginTapped(_ sender:
                    Any) {
//    saves the text inputs to variables
     guard
        let email = EmailField.text,
        let password = PasswordField.text
     else {return}
        
        //set the url of the api
        let url = URL(string:  "https://r316dbbv9l.execute-api.ap-southeast-2.amazonaws.com/Version2-POST/login")
        
        //make a request object with the url
        var request = URLRequest(url: url!)
        //attach the json body to he request
        //pass in the text inputs
        let jsonbody = [  "Email": email, "Password": password]
        //making sure to convet it to json and attach it, testing if it breaks
        do
        {
            let requestBody = try JSONSerialization.data(withJSONObject: jsonbody, options: .fragmentsAllowed)
            request.httpBody = requestBody
        }
        catch
        {
            print("error creating request body")
        }
        
        
        //set the method to POST
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        var UserExists = "False"
        
        //make the request
        MyVariables.dataTaskFinished = false
        let dataTask =  session.dataTask(with: request) { data, response, error in
        //decode the request and print the result
        UserExists = String(decoding: data!, as: UTF8.self)
            /// USEREXISTS
            
            print(UserExists)
            if (UserExists.contains("True")){
                MyVariables.UserExists = "True"
                MyVariables.dataTaskFinished = true
                return
                
                
               
            }
            else
            {
                MyVariables.UserExists = "False"
                MyVariables.dataTaskFinished = true
                return
            }
            
             //returns true or false string
            
        }
        
        //resume the datatask
        
        dataTask.resume()
        
        while (MyVariables.dataTaskFinished == false){
            print("waiting")
        }
        
        if (MyVariables.UserExists == "True"){
        let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartMain")
        self.addChild(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        }
        else{
            ///SAY WRONG EMAIL OR PASSWORD
            //print("wrong email or password")
            
            // create the alert
            let alert = UIAlertController(title: "Error", message: "Wrong password or email", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
        
           
    }
}
extension LoginViewController : UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
        
    }
    
    



            
          
            
     
    
        




