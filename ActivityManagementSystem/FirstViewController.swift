//
//  FirstViewController.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/5/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UITableViewController {
    
    var activities = [NSDictionary]()
    var imageView = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "主页"
        self.tableView.showsVerticalScrollIndicator = false;
        loadData()
    }
    
    func loadData(){
        let params = ["name": "query"]
        
        Alamofire.request(.GET, "http://112.74.166.187:8443/api/activities", parameters: params)
            .responseJSON {
                response in
                let result = response.result.value as! NSDictionary
                self.activities = result["data"] as! [NSDictionary]
                
                //print(self.activities.count)
                self.tableView.reloadData()
        }
        Alamofire.request(.GET, "http://112.74.166.187:8443/api/popular-images")
            .responseJSON {
                response in
                let images = response.result.value as! [NSDictionary]
                for image in images {
                    self.imageView.append(image["link"] as! String)
                }
                //print(self.imageView.count)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let row = indexPath.row
        let item = self.activities[row]
        let votings = item["votings"] as? [NSDictionary]
        let attachments = item["attachments"] as? [NSDictionary]
        if attachments!.count == 0 {
        if (votings?.count == 0) {
            let url = NSURL(string: "http://112.74.166.187:8443/modules/activities/client/img/news.jpg")
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            cell.imageView?.image = image?.reSizeImage(CGSize(width: 48, height: 48))
        } else {
            let url = NSURL(string: "http://112.74.166.187:8443/modules/activities/client/img/vote.jpg")
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            cell.imageView?.image = image?.reSizeImage(CGSize(width: 48, height: 48))
        }
        } else {
            let urlStr = attachments![0]["link"] as! String
            let url = NSURL(string: urlStr)
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            cell.imageView?.image = image?.reSizeImage(CGSize(width: 48, height: 48))
        }
        cell.textLabel!.text = item["title"] as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 200
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            let frame = CGRectMake(0, 0, view.bounds.width, view.bounds.width*0.48)
            //let imageView = ["2.png","3.png","1.png"]
            
            let loopView = XHAdLoopView(frame: frame, images: self.imageView, autoPlay: true, delay: 3, isFromNet: true)
            loopView.delegate = self
            return loopView
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //print("You deselected cell #\(indexPath.row)!")
        let item = self.activities[indexPath.row]
        let votings = item["votings"] as? [NSDictionary]
        if (votings?.count == 0) {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("activityViewController") as! ActivityViewController
            vc.activityId = (item["_id"] as! String)
            //vc.htmlContent = (item["htmlContent"] as! String)
            //vc.comments = (item["comments"] as! [NSDictionary])
            self.navigationController!.pushViewController(vc, animated: true)
        } else {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewControllerWithIdentifier("voteViewController") as! VoteViewController
            vc.activityId = (item["_id"] as! String)
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
    }
    

}

extension FirstViewController : XHAdLoopViewDelegate {
    func adLoopView(adLoopView: XHAdLoopView, IconClick index: NSInteger) {
        //print(index)
    }
}

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.mainScreen().scale);
        self.drawInRect(CGRectMake(0, 0, reSize.width, reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize)
        return reSizeImage(reSize)
    }
}