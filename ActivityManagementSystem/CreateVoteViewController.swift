//
//  CreateVoteViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/6/17.
//  Copyright © 2017 Jack. All rights reserved.
//


import UIKit
class CreateVoteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    var tableView:UITableView!
    var allNames:Dictionary<Int, [String]>!
    var addHeaders:[String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "投票"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CreateVoteViewController.commit(_:)))
        
        allNames =
            [
                0:[String](["投票内容..."]),
                1:[String](["选项", "T选项", "U选项", "I选项"])
        ]
        
        print(allNames)
        
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
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction))
        longPress.delegate = self
        longPress.minimumPressDuration = 1
//        tableView .addGestureRecognizer(longPress)
    }
    
    func longPressAction(recognizer:UILongPressGestureRecognizer)  {
        
        if recognizer.state == UIGestureRecognizerState.Began {
            print("UIGestureRecognizerStateBegan");
        }
        if recognizer.state == UIGestureRecognizerState.Changed {
            print("UIGestureRecognizerStateChanged");
        }
        if recognizer.state == UIGestureRecognizerState.Ended {
            print("UIGestureRecognizerStateEnded");
            
            if tableView.editing == true {
                tableView.editing = false
            }
            else
            {
                tableView.editing = true
            }
            
            tableView.reloadData()
        }
    }
    
    // 创建分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return allNames.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return allNames.count
    }
    
    // 每个分区的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count =  allNames[section]!.count
        if section == 1 && tableView.editing {
            count += 1
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
        let data = allNames[secno]
        
        var cell = UITableViewCell()
        
        if secno == 0 {
            cell = InputTableViewCell()
        }
        else if secno == 1
        {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identify)
            
            
            if tableView.editing && indexPath.row == data?.count {
                cell.textLabel?.text = "添加选项..."
                let button:UIButton = UIButton(type:UIButtonType.System) as UIButton;
                button.frame=CGRectMake(10, 150, 100, 30);
                button.setTitle("按钮", forState:UIControlState.Normal)
                cell.addSubview(button)
            }
            else
            {
                cell.textLabel?.text = data?[indexPath.row]
                cell.detailTextLabel?.text = "\(data![indexPath.row])的详解"
            }
        }
        
        return cell
        
    }
    
    // cell的选中事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 确定该分组的内容
        let str = allNames[indexPath.section]?[indexPath.row]
        print("str\(str)")
    }
    
    // 设置单元格的编辑的样式
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 {
            
            if tableView.editing == false {
                return UITableViewCellEditingStyle.None
            }
            else if indexPath.row == allNames[indexPath.section]?.count {
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
        print(editingStyle);
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.allNames[indexPath.section]?.removeAtIndex(indexPath.row)
        }
            
        else if editingStyle == UITableViewCellEditingStyle.Insert
        {
            allNames[indexPath.section]?.insert("插入的", atIndex: indexPath.row)
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
        print("commit")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 
}
