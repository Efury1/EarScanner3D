//
//  ChangeEmailViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 25/9/21.
//

import UIKit

class ChangeEmailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var OldEmail: UITextField!
    
    @IBOutlet weak var NewEmail: UITextField!
    
    @IBAction func ChangeEmailProfile(_ sender: UIButton) {
        
        let OldEmailText = OldEmail.text;
        let NewEmailText = NewEmail.text;
       
        
       
        let url = URL(string:
                            "https://oty2gz2wmh.execute-api.ap-southeast-2.amazonaws.com/default/emailprofile")

            var request = URLRequest(url: url!) //make a request object with the url
           
            let jsonbody = [ "NewEmail": NewEmailText!, "OldEmail": OldEmailText!] //attach the json body to he request. pass in the text inputs
       
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
        
        if (APIResponse.contains("True")){
            DispatchQueue.main.async {
            let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartMain")
           
            childViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            self.present(childViewController, animated: true, completion: nil)
       
        //if the passwords are the same hit the API to change the password where the email is this one
            }
        }
        else if (APIResponse.contains("False")){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "Old Password Doesnt Exist in System", preferredStyle: UIAlertController.Style.alert) //create alert
                                        //I'm a pop up
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
                    self.present(alert, animated: true, completion: nil)
            }
        }
    
    else{
        DispatchQueue.main.async {
        let alert = UIAlertController(title: "Error", message: "An Error Has Occured", preferredStyle: UIAlertController.Style.alert) //create alert
                                //I'm a pop up
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
            self.present(alert, animated: true, completion: nil)
        }
    }
        }
            dataTask.resume()
    }
}
