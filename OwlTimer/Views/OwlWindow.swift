//
//  OwlWindow.swift
//  OwlTimer
//
//  Created by Warren Burton on 29/07/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa

class OwlWindow: NSPanel {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: [.borderless,.utilityWindow], backing: .buffered , defer: false)
        //self.hasShadow = false
        self.backgroundColor = .clear
        self.isOpaque = false
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
}
