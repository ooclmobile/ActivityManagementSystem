//
//  SecondViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/5/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "我的"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath)

        let row = indexPath.row
        switch (row) {
        case 0:
            cell.textLabel!.text = "我的收藏"
            break;
        case 1:
            cell.textLabel!.text = "我的投票"
            break;
        case 2:
            cell.textLabel!.text = "退出登录"
            break;
        default:
            break;
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("You deselected cell #\(indexPath.row)!")
        let row = indexPath.row
        switch (row) {
        case 0,1:
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("myListViewController") as! MyListViewController
            if row == 0 {
                vc.title = "我的收藏"
            } else {
                vc.title = "我的投票"
            }
            self.navigationController!.pushViewController(vc, animated: true)
            break;
        case 2:
            break;
        default:
            break;
        }
    }

}

