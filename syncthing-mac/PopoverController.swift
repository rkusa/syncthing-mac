//
//  PopoverController.swift
//  syncthing-mac
//
//  Created by Markus Ast on 13.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

class PopoverController: NSObject {
    @IBOutlet weak var state: StateController!
    @IBOutlet weak var popover: NSPopover!
    
    var popoverMonitor: AnyObject?
    
    override func awakeFromNib() {
        if let statusButton = state.button {
            statusButton.action = "statusItemClicked:"
            statusButton.target = self
        }
    }
    
    func statusItemClicked(sender: AnyObject) {
        if popover.shown == false {
            openPopover(sender)
        }
        else {
            closePopover()
        }
    }
    
    func openPopover(sender: AnyObject) {
        if let statusButton = state.button {
            statusButton.highlight(true)
            popover.showRelativeToRect(sender.bounds, ofView: statusButton, preferredEdge: NSRectEdge.MinY)
            popoverMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(.LeftMouseDownMask, handler: {
                (event: NSEvent) -> () in
                self.closePopover()
            })
        }
    }
    
    func closePopover() {
        popover.close()
        if let statusButton = state.button {
            statusButton.highlight(false)
        }
        if let monitor : AnyObject = popoverMonitor {
            NSEvent.removeMonitor(monitor)
            popoverMonitor = nil
        }
    }
}

