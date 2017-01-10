//
//  InputTableViewCell.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/9/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell {
    var textView: UITextView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textView = UITextView(frame:CGRectMake(10.0, 20.0, 390.0, 80.0))
        self.textView!.layer.borderWidth = 1
        self.textView!.layer.borderColor = UIColor.grayColor().CGColor
        self.textView!.layer.cornerRadius = 6
        self.textView!.layer.masksToBounds = true
        self.contentView.addSubview(self.textView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
