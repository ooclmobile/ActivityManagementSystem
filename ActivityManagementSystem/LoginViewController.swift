//
//  LoginViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/10/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var savePasswordSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshFields()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"bg1.jpg")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        if self.user.text == "" || self.password.text == "" {
            return
        }
        var headers:Dictionary = [String:String]()
        headers["content-type"] = "application/json"
        
        var params = [String:AnyObject]()
        params["usernameOrEmail"] = self.user.text
        params["password"] = self.password.text
        Alamofire.request(.POST, "http://112.74.166.187:8443/api/auth/signin", parameters:params , encoding: ParameterEncoding.JSON, headers: headers).responseJSON {
                response in
                //print(response.result.value)
            let result = response.result.value as! NSDictionary
            if result["message"] != nil && (result["message"] as! String) != "" {
                print("login fail")
            } else {
                NSUserDefaults.standardUserDefaults().setObject(self.user.text, forKey: "User")
                NSUserDefaults.standardUserDefaults().setObject(self.password.text, forKey: "Password")
                if self.savePasswordSwitch.on {
                    NSUserDefaults.standardUserDefaults().setObject("1", forKey: "savePassword")
                } else {
                    NSUserDefaults.standardUserDefaults().setObject("0", forKey: "savePassword")
                }
                self.performSegueWithIdentifier("login", sender: self)
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return false
    }
    
    func refreshFields() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let user = userDefault.stringForKey("User")
        let password = userDefault.stringForKey("Password")
        let savePassword = userDefault.stringForKey("savePassword")
        if (user != nil) {
            self.user.text = user
        }
        if (savePassword != nil && savePassword == "1" && password != nil) {
            self.password.text = password
        }
    }
}

