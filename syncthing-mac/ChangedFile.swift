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
    
    init(filename: String) {
        self.filename = filename
    }
}
