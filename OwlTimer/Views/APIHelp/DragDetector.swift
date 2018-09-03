//
//  RenderLayer.swift
//  OwlTimer
//
//  Created by Warren Burton on 29/07/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa

class DragDetector: NSView {

    var hasLock = false
    override func mouseDown(with event: NSEvent) {
        hasLock = true
    }
    
    override func mouseUp(with event: NSEvent) {
        hasLock = false
    }
    
    override func mouseDragged(with event: NSEvent) {
        if hasLock, let window = window {
            let dx = event.deltaX
            let dy = event.deltaY
            let translate = CGAffineTransform(translationX: dx, y: -dy)
            window.setFrameOrigin(window.frame.origin.applying(translate))
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor.clear.set()
        bounds.fill()
    }
}
