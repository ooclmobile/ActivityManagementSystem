//
//  CustomTableViewCell.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/7/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

typealias IndexPathClosure = (indexPath: NSIndexPath) ->Void

class CustomTableViewCell: UITableViewCell {
    
    var choiceBtn: UIButton?
    var displayLab: UILabel?
    
    var indexPath: NSIndexPath?
    
    var indexPathClosure: IndexPathClosure?
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initializeUserInterface()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:Initialize methods
    func initializeUserInterface() {
        
        self.choiceBtn = {
            let choiceBtn = UIButton(type: UIButtonType.Custom)
            choiceBtn.bounds = CGRectMake(0, 0, 30, 30)
            choiceBtn.center = CGPointMake(20, 22)
            choiceBtn.setBackgroundImage(UIImage(named: "iconfont-select"), forState: UIControlState.Normal)
            choiceBtn.setBackgroundImage(UIImage(named: "iconfont-selected"), forState: UIControlState.Selected)
            choiceBtn.addTarget(self, action: #selector(CustomTableViewCell.respondsToButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            return choiceBtn
        }()
        self.contentView.addSubview(self.choiceBtn!)
        
        self.displayLab = {
            let displayLab = UILabel()
            displayLab.bounds = CGRectMake(0, 0, 100, 30)
            displayLab.center = CGPointMake(CGRectGetMaxX(self.choiceBtn!.frame) + 60, CGRectGetMidY(self.choiceBtn!.frame))
            displayLab.textAlignment = NSTextAlignment.Left
            return displayLab
        }()
        self.displayLab!.frame = CGRectMake(40, 0, 350, 40)
        self.displayLab!.numberOfLines = 0
        self.contentView.addSubview(self.displayLab!)
        
    }
    
    // MARK:Events
    func respondsToButton(sender: UIButton) {
        sender.selected = true
        if self.indexPathClosure != nil {
            self.indexPathClosure!(indexPath: self.indexPath!)
        }
    }
    
    
    // MARK:Private
    func setChecked(checked: Bool) {
        
        self.choiceBtn?.selected = checked
        
    }
    
    func getIndexWithClosure(closure: IndexPathClosure?) {
        self.indexPathClosure = closure
    }
}
