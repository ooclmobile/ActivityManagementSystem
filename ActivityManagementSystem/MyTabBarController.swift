//
//  MyTabBarController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/15/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var items: [UITabBarItem] = self.tabBar.items! as [UITabBarItem]
        //设置默认图片直接在IB添加新tabBar的时候Image选择好，这里是修改被选中时的图片
        //通过name获取图片，将设计切好的图 放到Images.xcassets中
        let tabbar0SelectedImage = UIImage(named: "home_shape")
        let tabbar1SelectedImage = UIImage(named: "round_add")
        let tabbar2SelectedImage = UIImage(named: "my_shape")
        //因为我的项目就三个tabbarItem
        //设置selectedImage
        items[0].selectedImage = tabbar0SelectedImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        items[1].selectedImage = tabbar1SelectedImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        items[2].selectedImage = tabbar2SelectedImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBar.tintColor = UIColor.yellowColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}