//
//  OwlWindow.swift
//  OwlTimer
//
//  Created by Warren Burton on 29/07/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa

class OwlWindow: NSWindow {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: [.borderless], backing: .buffered , defer: flag)
        isOpaque = false
        backgroundColor = .clear
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
}

extension NSWindow {
    func redrawShadow() {
        hasShadow = false
        display()
    }
}

