//
//  ViewController.swift
//  TodoTask
//
//  Created by Guest User on 4/23/15.
//  Copyright (c) 2015 Guest User. All rights reserved.
//

import UIKit
import Firebase

var ref = Firebase(url: "https://boiling-fire-8556.firebaseio.com/")
var dictOfUid =  [String:String]()
var uidDictForLogin = [:]
var uniqueId = ""
var uidValues = []
var uidKeys = []
var globalValues = ""
var globalKeys = ""


class ViewController: UIViewController {

    
    //signup outlet
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupUserName: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    
    
    
    //login outlet
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginUserName: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
   
    
    
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupView.hidden = true
        navItem.title = "Login"
        
        

        
    }
    
    
    
    
    //signup button action
    
    @IBAction func signupDoneBtnAction(sender: AnyObject) {
        var signupUserNameText = signupUserName.text!
        var signupUserPwdText = signupPassword.text!
        
        if (signupUserName.text!.isEmpty || signupPassword.text!.isEmpty) {
            
            let alert = UIAlertView()
            alert.title = "WARINING"
            alert.message = "PLease prvide text infield"
            alert.addButtonWithTitle("ok")
            alert.show()
            
            
        }
        else {
            
            ref.createUser("\(signupUserNameText)", password: "\(signupUserPwdText)",
                withValueCompletionBlock: { error, result in
                    
                    print(error)
                    print(result)
                    if error != nil {
                        // There was an error creating the account
                        print(error)
                        
                    } else {
                        
                        let uid = result["uid"] as? String
                        print("Successfully created user account with uid: \(uid)")
                        
                        
                    }
            })
            
            ref.authUser("\(signupUserNameText)", password: "\(signupUserPwdText)") {
                error, authData in
                if error != nil {
                    
                    print("error in logging in")
                    
                }
                else {
                    
                    let newUser = [
                        "provider": authData.provider,
                        "email": authData.providerData["email"] as? NSString as? String
                    ]
                    ref.childByAppendingPath("users")
                        .childByAppendingPath(authData.uid).setValue(newUser)
                    self.performSegueWithIdentifier("Login", sender: self)
                    signupUserNameText = ""
                    signupUserPwdText = ""
                    
                }
                
            }
//            signupView.hidden = true
//            loginView.hidden = false
//            navItem.title = "Login"
            
        }
        
    }

    
    
    @IBAction func signupCancelBtnAction(sender: AnyObject) {
        signupUserName.text = nil
        signupPassword.text = nil
        
        signupView.hidden = true
        loginView.hidden = false
        navItem.title = "Login"

    }
    
    
    
    
   //login button action
    
    @IBAction func loginBtnAction(sender: AnyObject) {
        var loginUserText = loginUserName.text!
        var loginPwdText = loginPassword.text!
        
        if loginUserText.isEmpty || loginPwdText.isEmpty {
            
            let alert = UIAlertView()
                            alert.title = "WARINING"
                            alert.message = "PLease prvide text infield"
                            alert.addButtonWithTitle("ok")
                            alert.show()
                            
                        }
        else {

        
        ref.authUser("\(loginUserText)", password: "\(loginPwdText)") {
            error, authData in
            print(authData)
            //print(error)
            
            if error != nil {
               
                print(error)
                
                print("error in logging in")
                
            }
            else {
                
                
               self.performSegueWithIdentifier("Login", sender: self)
                loginUserText = ""
                loginPwdText = ""
                
            }
        
            }
        
        }
       
        
    }
    
    @IBAction func signupBtnAction(sender: AnyObject) {
        signupView.hidden = false
        loginView.hidden = true
        navItem.title = "SignUp"

    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

