//
//  Api.swift
//  syncthing-mac
//
//  Created by Markus Ast on 12.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

struct Api {
    var address : NSURL
    
    func ping(callback: (Bool) -> ()) {
        request("rest/system/ping") { data, error in
            if error != nil {
                callback(false)
            }
            
            if let ping = data?["ping"] as? String {
                callback(ping == "pong")
            } else {
                callback(false)
            }
        }
        
    }
    
    func events(since: Int, callback: ((NSArray?, NSError!) -> ())?) {
        
    }
    
    func request(path: String, callback: ((NSDictionary?, NSError!) -> ())?) {
        NSURLSession.sharedSession().dataTaskWithURL(address.URLByAppendingPathComponent(path)) { data, response, error in
            if error != nil {
                callback?(nil, error)
                return
            }
            
            var parseError: NSError?
            if let dict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError) as? NSDictionary {
                callback?(dict, error)
                return
            }
            
            if parseError != nil {
                callback?(nil, parseError)
                return
            }
            
            callback?(nil, nil)
        }.resume()
    }
}
