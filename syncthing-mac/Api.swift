//
//  Api.swift
//  syncthing-mac
//
//  Created by Markus Ast on 12.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

struct Api {
    var address: NSURL
    
    let dateFormatter = NSDateFormatter()
    init(address: NSURL) {
        self.address = address
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSXXX"
    }
    
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
    
    func events(since: Int, callback: (([Event]?, Int, NSError!) -> ())?) {
        request("rest/events?since=\(since)") {
            data, error in
            if (data != nil && error == nil) {
                var lastId: Int = 0
                
                if let rows = data as? NSArray {
                    var events = [Event]()
                    
                    for var i = 0; i < rows.count; ++i {
                        if let row = rows.objectAtIndex(i) as? NSDictionary {
                            lastId = row["id"] as! Int
                            
                            if let type = EventType(rawValue: row["type"] as! String) {
                                let event = Event(
                                    id: row["id"] as! Int,
                                    type: type,
                                    time: self.dateFormatter.dateFromString(row["time"] as! String)!,
                                    data: row["data"] as! NSDictionary
                                )
                                events.append(event)
                            }
                            
                        }
                    }
                    
                    callback?(events, lastId, nil)
                    return
                }
            }
            
            callback?(nil, 0, error)
        }
    }
    
    func request(path: String, callback: ((AnyObject?, NSError!) -> ())?) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: path, relativeToURL: address)!) {
            data, response, error in
            if error != nil {
                callback?(nil, error)
                return
            }
            
            // TODO: Status Code error
            
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            var parseError: NSError?
            if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError) {
                callback?(json, error)
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

enum EventType:String {
    case RemoteIndexUpdated = "RemoteIndexUpdated"
    case ItemStarted = "ItemStarted"
    case ItemFinished = "ItemFinished"
}

struct Event {
    let id: Int
    let type: EventType
    let time: NSDate
    let data: NSDictionary
}

