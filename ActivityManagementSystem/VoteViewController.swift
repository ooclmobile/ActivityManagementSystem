//
//  VoteViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/7/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import Alamofire

class VoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var tableView: UITableView?
    var activityId = String()
    var question = String()
    var answers = [NSDictionary]()
    var isVoted = false
    
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "投票"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(VoteViewController.commit(_:)))
        
        loadData()
    }
    
    func loadData() {
        Alamofire.request(.GET, ("http://112.74.166.187:8443/api/activities/" + activityId))
            .responseJSON {
                response in
                let result = response.result.value as! NSDictionary
                let activity = result["data"] as! NSDictionary
                //print(activity)
                self.refreshData(activity)
                
        }
    }
    
    func refreshData(activity: NSDictionary) {
        question.removeAll()
        answers.removeAll()
        let votings = (activity["votings"] as! [NSDictionary])
        if votings[0]["isVoted"] != nil && !(votings[0]["isVoted"] is NSNull) {
        self.isVoted = votings[0]["isVoted"] as! Bool
        if self.isVoted {
            self.navigationItem.rightBarButtonItem = nil
        }
        }
        let title = (votings[0]["title"] as! String)
        self.question = title
        self.answers = (votings[0]["options"] as! [NSDictionary])
        
        self.initializeUserInterface()
    }
    
    func initializeUserInterface() {
        self.automaticallyAdjustsScrollViewInsets = false
        // table view
        self.tableView = {
            let tableView = UITableView(frame: CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)), style: UITableViewStyle.Grouped)
            tableView.dataSource = self
            tableView.delegate = self
            return tableView
        }()
        self.view.addSubview(self.tableView!)
        
    }
    
    func commit(sender: AnyObject) {
        //print("commit")
        if self.selectedIndexPath == nil {
            return
        }
        var headers:Dictionary = [String:String]()
        headers["content-type"] = "application/json"
        
        var params = [String:AnyObject]()
        params["selection"] = self.selectedIndexPath!.row
        Alamofire.request(.POST, ("http://112.74.166.187:8443/api/activities/action/vote/" + activityId + "/0"), parameters:params , encoding: ParameterEncoding.JSON, headers: headers).responseJSON {
            response in
            let result = response.result.value as! NSDictionary
            let activity = result["data"] as! NSDictionary
            self.refreshData(activity)
        }
    }
    
    // MARK:UITableViewDataSource && UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CustomTableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? CustomTableViewCell
        if cell == nil {
            cell = CustomTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        cell?.indexPath = indexPath
        self.selectedIndexPath?.row == indexPath.row ? cell?.setChecked(true) : cell?.setChecked(false)
        
        cell!.getIndexWithClosure { (indexPath) -> Void in
            self.selectedIndexPath = indexPath
            tableView.reloadSections(NSIndexSet(index: self.selectedIndexPath!.section), withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        if self.isVoted {
            cell?.choiceBtn?.hidden = true
            let option = answers[indexPath.row]
            let description = option["description"] as! String
            let voteDetails = option["voteDetails"] as! [NSDictionary]
            cell!.displayLab?.text = description + " (" + voteDetails.count.description + "票)"
        } else {
            cell?.choiceBtn?.hidden = false
            cell!.displayLab?.text = answers[indexPath.row]["description"] as? String
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.question
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.whiteColor()
        let titleLabel = UILabel()
        titleLabel.text = self.question
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.center = CGPoint(x: 20, y: 20)
        titleLabel.sizeToFit()
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hidesBottomBarWhenPushed = true
    }
}
