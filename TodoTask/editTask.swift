//
//  editTask.swift
//  TodoTask
//
//  Created by Panacloud on 4/27/15.
//  Copyright (c) 2015 Guest User. All rights reserved.
//

import UIKit

class editTask: UIViewController {
    
    //outlet for textFields
    @IBOutlet weak var editTaskNameField: UITextField!
    @IBOutlet weak var editTaskDescField: UITextField!
   
    
    //var declaration
    var todoItems:[String: addtask] = [:]
    var editTaskName: String!
    var editTaskDesc: String!
    var oldKey: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTaskNameField.text = editTaskName as String!
        editTaskDescField.text = editTaskDesc as String!
        
    }




    //edit task Button Action
    @IBAction func editBtnAction(sender: AnyObject) {
        
        if (editTaskNameField.text!.isEmpty || editTaskDescField.text!.isEmpty) {
            
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
                let childId = postRef.childByAppendingPath(self.oldKey)
                
                
                let editTask = [
                    "TaskName": self.editTaskNameField.text,
                    "TaskDescription": self.editTaskDescField.text,
                    "Key": self.oldKey
                    
                ]
                childId.updateChildValues(editTask)
                
                self.performSegueWithIdentifier("editBack", sender: self)
                
                
                
                
                
                
                
                
                
            } else {
                // No user is logged in
                print("you are not logged in")
                
                
            }
            
        })
        }
        
        
    }

        
    

        
    



    
    @IBAction func editCancelBtnAction(sender: AnyObject) {
        editTaskNameField.text = nil
        editTaskDescField.text = nil
    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }



}
