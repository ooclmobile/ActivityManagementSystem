//
//  CreateVoteViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/6/17.
//  Copyright © 2017 Jack. All rights reserved.
//


import UIKit
import Alamofire

class CreateVoteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    var tableView:UITableView!
    var addHeaders:[String]!
    var voteDetail = ""
    var voteOptions = [String](["",""])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "投票"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateVoteViewController.commit(_:)))
        
        addHeaders = ["投票内容","选项"]
        // 创建表格
        tableView = UITableView.init(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
        
        // 注册cell
        tableView.registerClass(UITableViewCell.self,forCellReuseIdentifier: "cell")
        tableView.editing = true
        
    }
    
    // 创建分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    // 每个分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count =  1
        if section == 1 && tableView.editing {
            count = voteOptions.count + 1
        }
        
        return count
        
    }
    
    // 分区头部显示
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return addHeaders[section]
    }
    
    // 显示cell内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let identify = "cell"
        
        let secno = indexPath.section
        let data = voteOptions
        
        var cell = UITableViewCell()
        
        if secno == 0 {
            //cell = InputTableViewCell()
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identify)
            let textView = UITextView(frame:CGRectMake(10.0, 20.0, 390.0, 80.0))
            //textView.layer.borderWidth = 1
            //textView.layer.cornerRadius = 6
            textView.layer.borderColor = UIColor.blackColor().CGColor
            textView.font = UIFont.systemFontOfSize(17)
            textView.delegate = self
            textView.text = voteDetail
            cell.contentView.addSubview(textView)
        }
        else if secno == 1
        {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identify)
            
            
            if tableView.editing && indexPath.row == voteOptions.count {
                cell.textLabel?.text = "添加选项..."
            }
            else
            {
                let textField = UITextField(frame: CGRectMake(10.0,0.0,300.0,40.0))
                textField.layer.borderWidth = 1
                textField.tag = indexPath.row
                textField.addTarget(self, action: #selector(CreateVoteViewController.textFieldValueChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
                textField.text = data[indexPath.row]
                cell.contentView.addSubview(textField)

            }
        }
        
        return cell
        
    }
    
    // cell的选中事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // 设置单元格的编辑的样式
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 {
            
            if tableView.editing == false {
                return UITableViewCellEditingStyle.None
            }
            else if indexPath.row == voteOptions.count {
                return UITableViewCellEditingStyle.Insert
            }else {
                return UITableViewCellEditingStyle.Delete
            }
        }
        return UITableViewCellEditingStyle.None
    }
    
    // 设置确认删除按钮的文字
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath:NSIndexPath) -> String? {
        return "确认删除"
    }
    
    // 单元格编辑后的响应方法
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //print(editingStyle);
        if editingStyle == UITableViewCellEditingStyle.Delete {
            voteOptions.removeAtIndex(indexPath.row)
        }
            
        else if editingStyle == UITableViewCellEditingStyle.Insert
        {
            voteOptions.insert("", atIndex: indexPath.row)
        }
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return 48
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func commit(sender: AnyObject) {
        //print("commit")
        var headers:Dictionary = [String:String]()
        headers["content-type"] = "application/json"
        
        var params:Dictionary = [String:AnyObject]()
        params["title"] = self.voteDetail
        params["description"] = self.voteDetail
        params["selectionType"] = "single" //multi
        var options = [AnyObject]()
        var optionItem = [String:AnyObject]()
        var  i = 1
        for option in self.voteOptions {
            optionItem["sequence"] = i
            optionItem["description"] = option
            options.append(optionItem)
            i = i + 1
        }
        params["options"] = options
        print(params)
        
        Alamofire.request(.POST, "http://112.74.166.187:8443/api/activities/votings/create", parameters:params , encoding: ParameterEncoding.JSON, headers: headers).responseJSON {
            response in
            print(response.result.value)
            self.voteDetail = ""
            self.voteOptions.removeAll()
            self.voteOptions.insert("", atIndex: 0)
            self.voteOptions.insert("", atIndex: 1)
            self.tableView.reloadData()
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func textFieldValueChanged(sender: AnyObject) {
        voteOptions[sender.tag] = sender.text
    }
    
    func textViewDidChange(textView: UITextView) {
        voteDetail = textView.text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 
}
