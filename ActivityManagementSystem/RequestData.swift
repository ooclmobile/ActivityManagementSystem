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
        Alamofire.request(.GET, "http://112.74.166.187:8443/api/activities")
            .responseJSON {
                response in
                let result = response.result.value as! NSDictionary
                let activities = result["data"] as! [NSDictionary]
                print(activities.count)

        }
    }

}