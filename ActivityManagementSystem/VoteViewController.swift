//
//  VoteViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/7/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import Charts
import Alamofire

class VoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChartViewDelegate{
    
    var tableView: UITableView?
    var activityId = String()
    var question = String()
    var answers = [NSDictionary]()
    var isVoted = false
    
    var selectedIndexPath: NSIndexPath?
    var barChartView: BarChartView!
    var testName = [String]()
    var unitsSold = [Double]()
    
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
        self.testName.removeAll()
        self.unitsSold.removeAll()
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
        for option in answers {
            let description = option["description"] as! String
            if option["voteDetails"] != nil && !(option["voteDetails"] is NSNull) {
            let voteDetails = option["voteDetails"] as! [NSDictionary]
            self.testName.append(description)
            self.unitsSold.append(Double(voteDetails.count))
            }
        }
        self.initializeUserInterface()
    }
    
    func initializeUserInterface() {
        self.automaticallyAdjustsScrollViewInsets = false
        // table view
        self.tableView = {
            let tableView = UITableView(frame: CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)), style: UITableViewStyle.Plain)
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
        params["selection"] = (self.selectedIndexPath!.row + 1)
        Alamofire.request(.POST, ("http://112.74.166.187:8443/api/activities/action/vote/" + activityId + "/0"), parameters:params , encoding: ParameterEncoding.JSON, headers: headers).responseJSON {
            response in
            //print(response.result.value)
            if response.result.value != nil {
            let result = response.result.value as! NSDictionary
            let activity = result["data"] as! NSDictionary
            self.refreshData(activity)
            }
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
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.whiteColor()
        barChartView = BarChartView.init(frame: CGRectMake(0, 64, 200, 200))
        
        barChartView.delegate = self
        
        setChart(self.testName, values: self.unitsSold)
        if self.isVoted {
            return barChartView
        } else {
            return footerView
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.descriptionText = ""
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: nil)
        let chartData = BarChartData(xVals: testName, dataSet: chartDataSet)
        barChartView.data = chartData
        chartData.setDrawValues(false)
        
        
        chartDataSet.colors = [UIColor(red: 250/255, green: 16/255, blue: 34/255, alpha: 1), UIColor(red: 235/255, green: 166/255, blue: 134/255, alpha: 1),UIColor(red: 135/255, green: 66/255, blue: 255/255, alpha: 1), UIColor(red: 35/255, green: 11/255, blue: 15/255, alpha: 1)]
        barChartView.xAxis.labelPosition = .Bottom
    }
    
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
        //need to set chartData.setDrawValues(true)
    }
    
    func setLabels() {
    }
    
    override func viewWillAppear(animated: Bool) {
        self.hidesBottomBarWhenPushed = true
    }
}
