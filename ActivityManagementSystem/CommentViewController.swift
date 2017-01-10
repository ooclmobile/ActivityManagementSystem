//
//  CommentViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/7/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "评论"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CommentViewController.commit(_:)))
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.grayColor().CGColor
        self.textView.layer.cornerRadius = 6
        self.textView.layer.masksToBounds = true
        
    }
    
    func commit(sender: AnyObject) {
        print("commit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hidesBottomBarWhenPushed = true
    }
}
