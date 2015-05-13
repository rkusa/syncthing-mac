//
//  ChangedFileViewItem.swift
//  syncthing-mac
//
//  Created by Markus Ast on 14.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

class ChangedFileViewItem: NSCollectionViewItem {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func clicked(sender: NSButton) {
        let api = (NSApplication.sharedApplication().delegate as! AppDelegate).api
        let filename = representedObject?.valueForKey("filename") as! String
        let folder = representedObject?.valueForKey("folder") as! String
        api.folder(folder) { folderPath in
            if folderPath != nil {
                if let fileLocation = folderPath?.URLByAppendingPathComponent(filename).URLByDeletingLastPathComponent {
                    NSWorkspace.sharedWorkspace().openURL(fileLocation)
                }
            }
        }
    }
}
