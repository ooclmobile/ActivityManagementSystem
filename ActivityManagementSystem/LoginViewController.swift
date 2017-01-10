//
//  LoginViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/10/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        if true {
            self.performSegueWithIdentifier("login", sender: self)
        }else{
            print("login fail")
        }
    }
}

