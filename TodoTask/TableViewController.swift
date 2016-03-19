//
//  TableViewController.swift
//  TodoTask
//
//  Created by Panacloud on 4/24/15.
//  Copyright (c) 2015 Guest User. All rights reserved.
//

import UIKit
import Firebase



class TableViewController: UITableViewController {
    
    var todoItems:[String:addtask] = [:]
    var userRef: Firebase!
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        ref.observeAuthEventWithBlock({ authData in
            if authData != nil {
              self.userRef = ref.childByAppendingPath("todo").childByAppendingPath(authData.uid)
                
                
                self.userRef.observeEventType(.ChildAdded, withBlock: { snapshot in

                    
                    let newName = snapshot.value.objectForKey("TaskName") as! String
                    let newDesc = snapshot.value.objectForKey("TaskDescription") as! String
                    let newKey = snapshot.key
                    

                    
                    let newTasks: addtask = addtask(name: newName, desc: newDesc, key: newKey)
                    self.todoItems[newKey] = newTasks
                    self.tableView.reloadData()
                    
                    
                    }, withCancelBlock: { error in
                        print(error.description)
                })
               
                self.observeDeletion()
                
                self.userRef.observeEventType(.ChildChanged, withBlock: { snapshot in
                    
                    
                    let newName = snapshot.value.objectForKey("TaskName") as! String
                    let newDesc = snapshot.value.objectForKey("TaskDescription") as! String
                    let newKey = snapshot.key
                    
                    
                    
                    let newTasks: addtask = addtask(name: newName, desc: newDesc, key: newKey)
                    self.todoItems[newKey] = newTasks
                    self.tableView.reloadData()
                    
                    
                    }, withCancelBlock: { error in
                        print(error.description)
                })
                
                
                print("login")
            } else {
                // No user is logged in
            }
        })
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signoutBtnAction(sender: AnyObject) {
        ref.unauth()
        self.performSegueWithIdentifier("Signout", sender: self)
        
    }
    
    func observeDeletion(){
        userRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
 
            let key = snapshot.value.objectForKey("Key") as! String
            self.todoItems[key] = nil
            self.tableView.reloadData()
            
        })
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("edit", sender: self)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell") as UITableViewCell!
        let key = Array(todoItems.keys)[indexPath.row]
        let item = todoItems[key]
        
        cell.textLabel?.text = item?.name
        cell.detailTextLabel?.text = item?.desc
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let key = Array(todoItems.keys)[indexPath.row]
            
            let delKey = self.userRef.childByAppendingPath(key)
            delKey.removeValue()
           
            
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        if segue?.identifier == "edit" {
            let selectedIndexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            let editTaskVC: editTask = segue?.destinationViewController as! editTask
            
            
            let key = Array(todoItems.keys)[selectedIndexPath.row]
            let item = todoItems[key] 
            editTaskVC.editTaskName = item?.name
            editTaskVC.editTaskDesc = item?.desc
            editTaskVC.oldKey = item?.key
            
        }
            
        
        
    }

    
    

}
