//
//  SignupViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 3/8/21.
//

import Foundation
import UIKit
import CoreData



class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var retypeEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerTextField: UIButton!
     
    //We will need to make sure retype passwords match
    //That password follows security protocoles
        //inserting text field data in database
        //Put function into button to make sure code is neat
        func insert() {
            //let email = emailTextField
            //let password = passwordTextField
            
            //Call API
            //If fails rreturn error
            
            
            
            do {
                print("Data saved")
                //To display an alert box
                //let actionController = UIAlertController(title: "Message", message: "Data added",  preferredStyle: <#UIAlertController.Style#>)
                //let okAction = UIAlertAction(title: "OK", style: .default)
            }
            
        }
        
    }



