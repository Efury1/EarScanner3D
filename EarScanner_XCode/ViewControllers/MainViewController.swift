//
//  MainViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 15/8/21.
//

import Foundation
import UIKit
public var GlobalPhotosetName = ""
class MainViewController: UIViewController {
    
    override func
    viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //Additional setup after loading view
    }
    

    
    /*fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedin")
    }
    
    func handleSignOut() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    func funalert() {
        let alert = UIAlertController(title: "Error", message: "Please Check Internet Connection", preferredStyle: UIAlertController.Style.alert) //create alert
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
        self.present(alert, animated: true, completion: nil)
    }*/
    
    @IBAction func logoutButton(_ sender: Any) {
        

        
        
        print("Users action was tapped")
        let refreshAlert = UIAlertController(title: "Log Out", message: "Are You Sure to Log Out ? ", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popToRootViewController(animated: true)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in

            refreshAlert .dismiss(animated: true, completion: nil)


        }))

        present(refreshAlert, animated: true, completion: nil)
    
    }
   
        
    
    
    @IBOutlet weak var PhotosetName: UITextField!
    
    
    @IBAction func StartCamera(_ sender: UIButton) {
       
        if (PhotosetName.text?.isEmpty == false && PhotosetName.text != nil && !(PhotosetName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            GlobalPhotosetName = PhotosetName.text ?? "Unnamed"
            
            let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Camera")
             self.addChild(childViewController)
             self.view.addSubview(childViewController.view)
             childViewController.didMove(toParent: self)
            
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Enter a name for the Photoset", preferredStyle: UIAlertController.Style.alert) //create alert
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
            self.present(alert, animated: true, completion: nil) // show the alert
            
        }
    }
    
    
    
}

