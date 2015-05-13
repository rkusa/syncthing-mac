//
//  StatusMenuController.swift
//  syncthing
//
//  Created by Markus Ast on 12.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var state: StateController!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var api: Api?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func awakeFromNib() {
        locateSyncthing()
    }
    
    func locateSyncthing() {
        state.discovery()
        
        if let address = Configuration.readAddress() {
            api = Api(address: address)
            pingSyncthing()
        } else {
            state.notFound()
        }
    }
    
    func pingSyncthing() {
        state.ping()
        
        api!.ping { pong in
            if pong {
                self.state.idle()
            } else {
                self.state.notResponding()
            }
        }
    }
    
    @IBAction func retryClicked(sender: NSButton) {
        locateSyncthing()
    }
    
    @IBAction func openUIClicked(sender: NSButton) {
         NSWorkspace.sharedWorkspace().openURL(api!.address)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }

}

