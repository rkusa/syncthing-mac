//
//  ChangedFileView.swift
//  syncthing-mac
//
//  Created by Markus Ast on 13.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

class ChangedFileView: NSView {
    var isHighlighted = false
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if isHighlighted {
            NSColor(white: 0, alpha: 0.1).setFill()
        } else {
            NSColor(white: 0, alpha: 0).setFill()
        }
        NSRectFill(dirtyRect)
    }

    override func mouseEntered(theEvent: NSEvent) {
        isHighlighted = true
        needsDisplay = true
    }
    
    override func mouseExited(theEvent: NSEvent) {
        isHighlighted = false
        needsDisplay = true
    }
    
    var trackingArea: NSTrackingArea?
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if trackingArea != nil {
            removeTrackingArea(trackingArea!)
        }
        
        trackingArea = NSTrackingArea(rect: bounds, options: .MouseEnteredAndExited | .ActiveAlways, owner: self, userInfo: nil)
        addTrackingArea(trackingArea!)
    }
}
