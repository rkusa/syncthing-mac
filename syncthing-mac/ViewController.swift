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
    @IBOutlet weak var api: Api!
    
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
            api.address = address
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
                self.observeEvents(0)
            } else {
                self.state.notResponding()
            }
        }
    }
    
    var receiving = [String: Bool]()
    
    func observeEvents(since: Int) {
        api?.events(since) {
            events, lastId, error in
            if error != nil {
                print("Fail \(error)")
            }
            if events == nil {
                self.observeEvents(since)
            } else {
                var indexUpdated = false
                
                for event in events as [Event]! {
                    switch event.type {
                    case .RemoteIndexUpdated:
                        indexUpdated = true
                    case .ItemStarted:
                        let filename = event.data["item"] as! String
                        self.receiving[filename] = true
                    case .ItemFinished:
                        let filename = event.data["item"] as! String
                        self.receiving.removeValueForKey(filename)
                        let changedFile = ChangedFile(
                            filename: filename,
                            folder: event.data["folder"] as! String,
                            time: event.time
                        )
                        self.state.addChangedFile(changedFile)
                    }
                }
                
                if self.receiving.isEmpty && !indexUpdated {
                    self.state.idle()
                } else {
                    self.state.busy()
                }
                
                self.observeEvents(lastId)
            }
        }
    }
    
    @IBAction func retryClicked(sender: NSButton) {
        locateSyncthing()
    }
    
    @IBAction func openUIClicked(sender: NSButton) {
         NSWorkspace.sharedWorkspace().openURL(api.address!)
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }

}

