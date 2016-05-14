//
//  HttpRequest.swift
//  Corsaire
//
//  Created by Elie on 14/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation

class HttpRequest {
    var url: NSURL?
    init(endpoint: String){
        self.url = NSURL(string: endpoint)
    }
    
    init(url: NSURL){
        self.url = url
    }
    
    func post(data: NSDictionary, headers: Dictionary<String, String>, actionOnComplete: ((NSData?, NSURLResponse?, NSError?)->Void)?) throws ->Void{
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(data, options: .PrettyPrinted)
        var task = NSURLSessionDataTask()
        if let unwrappredActionOnComplete = actionOnComplete {
            task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: unwrappredActionOnComplete)
        }else{
            task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        }
        task.resume()
    }
    
    func get(actionOnComplete: ((NSData?, NSURLResponse?, NSError?)->Void)?) throws -> Void
    {
        let request = NSMutableURLRequest(URL: url!)
        var task = NSURLSessionDataTask()
        request.HTTPMethod = "GET"
        if let unwrappredActionOnComplete = actionOnComplete {
            task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: unwrappredActionOnComplete)
        }else{
            task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        }
        task.resume()
    }
}
