//
//  ActivityViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/7/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "详情"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self,forCellReuseIdentifier: "cell")

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let row = indexPath.row
        switch (row) {
        case 0:
            cell.textLabel!.text = "1"
            break;
        case 1:
            cell.textLabel!.text = "2"
            break;
        case 2:
            cell.textLabel!.text = "3"
            break;
        case 3:
            cell.textLabel!.text = "4"
            break;
        default:
            break;
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hidesBottomBarWhenPushed = true
    }
}