//
//  Configuration.swift
//  syncthing-mac
//
//  Created by Markus Ast on 12.05.15.
//  Copyright (c) 2015 Markus Ast. All rights reserved.
//

import Cocoa

struct Configuration {
    
    let syncthingSupportPath = "~/Library/Application Support/Syncthing"
    
    static func readAddress() -> NSURL? {
        let fm = NSFileManager.defaultManager()
        var err : NSError?
        let applicationSupport: NSURL?
        do {
            applicationSupport = try fm.URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        } catch let error as NSError {
            err = error
            applicationSupport = nil
        }
        
        if err != nil {
            return nil
        }
        
        // optional pyramid of doom
        if let configURL = applicationSupport?.URLByAppendingPathComponent("Syncthing/config.xml") {
            let config: NSXMLDocument?
            do {
                config = try NSXMLDocument(contentsOfURL: configURL, options: 0)
            } catch let error as NSError {
                err = error
                config = nil
            }
            
            if err != nil {
                return nil
            }
            
            if let rootNode = config?.rootElement() {
                if let guiNode = rootNode.elementsForName("gui").first as NSXMLElement? {
                    if let addressNode = guiNode.elementsForName("address").first as NSXMLElement? {
                        if let address = addressNode.stringValue {
                            if let url = NSURL(string: ((addressNode.attributeForName("tls")?.stringValue == "true" ? "https://" : "http://") + address)) {
                                return url
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
}
