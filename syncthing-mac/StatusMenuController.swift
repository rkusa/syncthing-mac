//
//  StatusMenuController.swift
//  syncthing
//
//  Created by Markus Ast on 12.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var statusMenuItem: NSMenuItem!
    @IBOutlet weak var retryMenuItem: NSMenuItem!
    @IBOutlet weak var openUIMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1) // -1 = NSVariableStatusItemLength
    var api : Api?
    
    override func awakeFromNib() {
        let icon = NSImage(named: "StatusIcon")
        icon?.setTemplate(true)
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        locateSyncthing()
    }
    
    func locateSyncthing() {
        statusMenuItem.title = NSLocalizedString("Looking for Syncthing ...", comment: "")
        if let address = Configuration.readAddress() {
            api = Api(address: address)
            openUIMenuItem.hidden = false
            pingSyncthing()
        } else {
            statusMenuItem.title = NSLocalizedString("Syncthing not found", comment: "")
            retryMenuItem.hidden = false
        }
    }
    
    func pingSyncthing() {
        statusMenuItem.title = NSLocalizedString("Ping Syncthing ...", comment: "")
        api!.ping { pong in
            if pong {
                self.statusMenuItem.hidden = true
            } else {
                self.statusMenuItem.title = NSLocalizedString("Synthing not responding", comment: "")
            }
        }
    }
    
    @IBAction func retryClicked(sender: NSMenuItem) {
        retryMenuItem.hidden = true
        locateSyncthing()
    }
    
    @IBAction func openUIClicked(sender: NSMenuItem) {
        NSWorkspace.sharedWorkspace().openURL(api!.address)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}