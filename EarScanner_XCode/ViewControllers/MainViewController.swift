//
//  MainViewController.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 15/8/21.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    static var GlobalPhotosetName = ""
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
   

    
    
    @IBAction func Logout(_ sender: UIButton) {
        print("Users action was tapped")
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            
            let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginPage")
            UIApplication.shared.windows.first?.rootViewController = viewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
            self.navigationController?.popToRootViewController(animated: true)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in

            refreshAlert .dismiss(animated: true, completion: nil)


        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
        
    
    
    @IBOutlet weak var PhotosetName: UITextField!
    
    
    @IBAction func StartFlow(_ sender: UIButton) {
       
        if (PhotosetName.text?.isEmpty == false && PhotosetName.text != nil && !(PhotosetName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            MainViewController.GlobalPhotosetName = PhotosetName.text ?? "Unnamed"
            print("photoset Name", MainViewController.GlobalPhotosetName)
            let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BeginFirstEar")
             self.addChild(childViewController)
             self.view.addSubview(childViewController.view)
             childViewController.didMove(toParent: self)
//            let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Camera")
//             self.addChild(childViewController)
//             self.view.addSubview(childViewController.view)
//             childViewController.didMove(toParent: self)
            
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Please enter a name for this photoset", preferredStyle: UIAlertController.Style.alert) //create alert
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil)) // add an action (button)
            self.present(alert, animated: true, completion: nil) // show the alert
            
        }
    }
    
    @IBAction func StartTutorial(_ sender: Any) {
        ViewController.counter = 0;
        let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Step1")
        self.parent?.present(childViewController, animated: true, completion: nil)
//         self.addChild(childViewController)
//         self.view.addSubview(childViewController.view)
    }
    
    @IBAction func FinishedFLow(_ sender: Any) {
        ViewController.SecondEar = false;
        let childViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartMain")
         self.addChild(childViewController)
         self.view.addSubview(childViewController.view)
         childViewController.didMove(toParent: self)
        
    }
    
}

