//
//  ChangedFile.swift
//  syncthing-mac
//
//  Created by Markus Ast on 13.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

class ChangedFile: NSObject {
    let filename: String
    let folder: String
    let time: NSDate
    
    var timeago: String {
        get {
            let formatter = NSDateComponentsFormatter()
            formatter.unitsStyle = .Full
            
            let calendar = NSCalendar.currentCalendar()
            
            let components = calendar.components(
                .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitWeekOfYear | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond,
                fromDate: time, toDate: NSDate(), options: nil
            )
            
            let year = components.year
            
            var timeago: String = ""
            if components.year > 0 {
                timeago = String(components.year) + " " + NSLocalizedString("years", comment: "")
            } else if components.month > 0 {
                timeago = String(components.month) + " " + NSLocalizedString("months", comment: "")
            } else if components.weekOfYear > 0 {
                timeago = String(components.weekOfYear) + " " + NSLocalizedString("weeks", comment: "")
            } else if components.day > 0 {
                timeago = String(components.day) + " " + NSLocalizedString("days", comment: "")
            } else if components.hour > 0 {
                timeago = String(components.hour) + " " + NSLocalizedString("hours", comment: "")
            } else if components.minute > 0 {
                timeago = String(components.minute) + " " + NSLocalizedString("minutes", comment: "")
            } else if components.second > 15 {
                timeago = String(components.second) + " " + NSLocalizedString("seconds", comment: "")
            } else {
                return NSLocalizedString("just now", comment: "")
            }
            
            return String(format: NSLocalizedString("%@ ago", comment: ""), timeago)
        }
    }
    
    init(filename: String, folder: String, time: NSDate) {
        self.filename = filename
        self.folder   = folder
        self.time     = time
    }
}
