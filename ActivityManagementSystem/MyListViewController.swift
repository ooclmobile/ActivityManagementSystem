//
//  MyListViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/10/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import Alamofire

class MyListViewController: UITableViewController {
    
    let url = "http://112.74.166.187:8443/api/activities"
    var activities = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
        print(self.activities.count)
    }
    
    func loadData(){
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON {
                response in
                print(response.result.value)
                self.activities = response.result.value as! [NSDictionary]
                
                print(self.activities.count)
                self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myListCell", forIndexPath: indexPath)
        let row = indexPath.row
        let item = self.activities[row]
        let votings = item["votings"] as? [NSDictionary]
        if (votings?.count == 0) {
            let image = UIImage(named:"1.png")
            cell.imageView?.image = image
        } else {
            let image = UIImage(named:"2.png")
            cell.imageView?.image = image
        }
        cell.textLabel!.text = item["title"] as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("You deselected cell #\(indexPath.row)!")
        let item = self.activities[indexPath.row]
        let votings = item["votings"] as? [NSDictionary]
        if (votings?.count == 0) {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("activityViewController") as! ActivityViewController
            vc.activityId = (item["_id"] as! String)
            self.navigationController!.pushViewController(vc, animated: true)
        } else {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("voteViewController") as! VoteViewController
            vc.activityId = (item["_id"] as! String)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
    }
    
    
}