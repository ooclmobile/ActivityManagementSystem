//
//  ActivityViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/7/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import Alamofire

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var collectBarButton: UIBarButtonItem!
    @IBOutlet weak var likeBarButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityLabel: UILabel!
    var activityId = String()
    var htmlContent = String()
    var comments = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "详情"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self,forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    func loadData() {
        Alamofire.request(.GET, ("http://112.74.166.187:8443/api/activities/" + activityId))
            .responseJSON {
                response in
                let result = response.result.value as! NSDictionary
                let activity = result["data"] as! NSDictionary
                self.refreshData(activity)
        }
    }
    
    func refreshData(activity: NSDictionary) {
        self.htmlContent = (activity["htmlContent"] as! String)
        self.comments = (activity["comments"] as! [NSDictionary])
        let createdBy = activity["createdBy"]!["displayName"] as!String
        let created = activity["created"] as! NSString
        if activity["isCollected"] != nil && !(activity["isCollected"] is NSNull) {
            let isCollected = activity["isCollected"] as! Bool
            if isCollected {
                self.collectBarButton.enabled = false
            }
        }
        if activity["isLiked"] != nil && !(activity["isLiked"] is NSNull) {
            let isLiked = activity["isLiked"] as! Bool
            if isLiked {
                self.likeBarButton.enabled = false
            }
        }
        let collects = (activity["collects"] as! [String])
        let likes = (activity["likes"] as! [String])
        let detail = likes.count.description + "赞 " + collects.count.description + "收藏"
        self.activityLabel.text = "创建者：" + createdBy + " 创建日期：" + created.substringToIndex(10) + " " + detail
        self.activityLabel.sizeToFit()
        self.webView.loadHTMLString(self.htmlContent.stringByReplacingOccurrencesOfString("/./", withString: "http://112.74.166.187:8443/", options: NSStringCompareOptions.LiteralSearch, range: nil),baseURL:nil)
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let comment = self.comments[indexPath.row]
        if comment["content"] is NSNull {
            cell.textLabel!.text = (comment["createdBy"] as? String)! + ": "
        } else {
            cell.textLabel!.text = (comment["createdBy"] as? String)! + ": " + (comment["content"] as? String)!
        }
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        loadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "comment" {
            let controller = segue.destinationViewController as! CommentViewController
            controller.activityId = self.activityId
        }
    }
    
    @IBAction func like(sender: AnyObject) {
        Alamofire.request(.GET, ("http://112.74.166.187:8443/api/activities/action/like/" + activityId))
            .responseJSON {
                response in
                let result = response.result.value as! NSDictionary
                let activity = result["data"] as! NSDictionary
                self.refreshData(activity)
        }
    }
    
    @IBAction func collect(sender: AnyObject) {
        Alamofire.request(.GET, ("http://112.74.166.187:8443/api/activities/action/collect/" + activityId))
            .responseJSON {
                response in
                let result = response.result.value as! NSDictionary
                let activity = result["data"] as! NSDictionary
                self.refreshData(activity)
        }
    }
    
}