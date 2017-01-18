//
//  RequestData.swift
//  ActivityManagementSystem
//
//  Created by Jack on 1/13/17.
//  Copyright © 2017 Jack. All rights reserved.
//

import Foundation
import Alamofire

class RequestData: NSObject{
    
    func request() {
        Alamofire.request(.GET, self.getUrl() + "/api/activities")
            .responseJSON {
                response in
                let result = response.result.value as! NSDictionary
                let activities = result["data"] as! [NSDictionary]
                print(activities.count)

        }
    }
    
    func getUrl() -> String{
        let plistPath = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dictData = NSDictionary(contentsOfFile: plistPath!)
        let url = dictData?.valueForKey("URL") as! NSDictionary
        let host = url.valueForKey("Host") as! String
        let port = url.valueForKey("Port") as! String
        return host + ":" + port
    }

}