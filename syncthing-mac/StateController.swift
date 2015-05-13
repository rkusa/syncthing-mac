//
//  State.swift
//  syncthing-mac
//
//  Created by Markus Ast on 13.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

class StateController: NSObject {
    
    @IBOutlet weak var viewController: ViewController!
    @IBOutlet weak var statusView: NSView!
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var stateLabel: NSTextField!
    @IBOutlet weak var retryButton: NSButton!
    @IBOutlet weak var arrayController: NSArrayController!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1) // -1 = NSVariableStatusItemLength
    let connectingIcon = NSImage(named: "StatusConnectingIcon")
    let brokenIcon = NSImage(named: "StatusBrokenIcon")
    let idleIcon = NSImage(named: "StatusIdleIcon")
    let busyIcon = NSImage(named: "StatusBusyIcon")
    
    var recentChanges = NSMutableArray()
    
    override func awakeFromNib() {
//        recentChanges.addObject(ChangedFile(filename: "Test"))
        arrayController.addObject(ChangedFile(filename: "Test"))
        arrayController.addObject(ChangedFile(filename: "Test"))
    }

    var button: NSStatusBarButton? {
        get {
            return statusItem.button
        }
    }
    
    func discovery() {
        viewController.view = statusView
        stateLabel.stringValue = NSLocalizedString("Looking for Syncthing ...", comment: "")
        retryButton.hidden = true
        button?.image = connectingIcon
    }
    
    func ping() {
        viewController.view = statusView
        stateLabel.stringValue = NSLocalizedString("Ping Syncthing ...", comment: "")
    }
    
    func notFound() {
        viewController.view = statusView
        stateLabel.stringValue = NSLocalizedString("Syncthing not found", comment: "")
        retryButton.hidden = false
        button?.image = brokenIcon
    }
    
    func notResponding() {
        viewController.view = statusView
        stateLabel.stringValue = NSLocalizedString("Synthing not responding", comment: "")
        retryButton.hidden = false
        button?.image = connectingIcon
    }
    
    func idle() {
        viewController.view = mainView
        button?.image = idleIcon
    }
    
}
