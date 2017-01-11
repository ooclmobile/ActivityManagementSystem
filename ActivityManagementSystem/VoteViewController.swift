//
//  VoteViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/7/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var tableView: UITableView?
    var activityId = String()
    var questions: [String]?
    var answers: [String:[String]]?
    
    
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeDatasource()
        self.initializeUserInterface()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK:Initialize methods
    func initializeDatasource() {
        self.questions = ["teambuild 去哪吃?"]
        
        self.answers = ["0":["888街", "食神", "和记", "大石浦"]]
        
    }
    
    func initializeUserInterface() {
        self.title = "投票"
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
    
    // MARK:UITableViewDataSource && UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.answers!.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = "\(section)"
        let answers = self.answers![key]
        return answers!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: CustomTableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? CustomTableViewCell
        
        if cell == nil {
            cell = CustomTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        cell?.indexPath = indexPath
        
        let key = "\(indexPath.section)"
        let answers = self.answers![key]
        
        self.selectedIndexPath?.row == indexPath.row ? cell?.setChecked(true) : cell?.setChecked(false)
        
        
        
        cell!.getIndexWithClosure { (indexPath) -> Void in
            
            self.selectedIndexPath = indexPath
            
            print("您选择的答案是：\(answers![indexPath.row])")
            
            tableView.reloadSections(NSIndexSet(index: self.selectedIndexPath!.section), withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        
        cell!.displayLab?.text = answers![indexPath.row]
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.questions![section]
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hidesBottomBarWhenPushed = true
    }
}
