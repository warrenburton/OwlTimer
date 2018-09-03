//
//  AppDelegate.swift
//  OwlTimer
//
//  Created by Warren Burton on 29/07/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        registerStandardDefaults()
    }
    
    func registerStandardDefaults() {
        guard let ref = Bundle.main.url(forResource: "StandardDefaults", withExtension: "plist"),
        let dictionary = NSDictionary(contentsOf: ref) as? [String:Any] else {
            fatalError("Unable to load StandardDefaults.plist in main bundle")
        }
        UserDefaults.standard.register(defaults: dictionary)
    }
    

}

