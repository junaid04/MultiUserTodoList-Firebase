//
//  addTaskVC.swift
//  TodoTask
//
//  Created by Panacloud on 4/24/15.
//  Copyright (c) 2015 Guest User. All rights reserved.
//

import UIKit

class addTaskVC: UIViewController {
    
    
    
    //Text field Outlet
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskDescField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println(ref.key)
    }
    
    
    
    
    @IBAction func saveBtnAction(sender: AnyObject) {
        
      //var myRef = Firebase(url: "https://boiling-fire-8556.firebaseio.com/")
        
        if (taskNameField.text!.isEmpty || taskDescField.text!.isEmpty) {
            
            let alert = UIAlertView()
            alert.title = "WARINING"
            alert.message = "PLease prvide text infield"
            alert.addButtonWithTitle("ok")
            alert.show()
            
        }
        else {
        
        ref.observeAuthEventWithBlock({ authData in
            if authData != nil {
                
                let postRef = ref.childByAppendingPath("todo").childByAppendingPath(authData.uid)
                let childId = postRef.childByAutoId()
                
                let newUser = [
                    "TaskName": self.taskNameField.text,
                    "TaskDescription": self.taskDescField.text,
                    "Key": childId.key
                ]
                childId.setValue(newUser)

                
               //var a = myRef.childByAppendingPath("todo").childByAppendingPath(authData.uid).childByAutoId().setValue(newUser)
                
                
//                println(childId)
               // self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("save", sender: self)
                
                
     


            
            } else {
                // No user is logged in
                 print("you are not logged in")
                
                
            }
            
        })
        
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func cancelBtnAction(sender: AnyObject) {
        
        taskNameField.text = nil
        taskDescField.text = nil
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

