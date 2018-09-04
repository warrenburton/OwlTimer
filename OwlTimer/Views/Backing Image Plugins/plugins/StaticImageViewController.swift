//
//  StaticImageViewController.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import AppKit
import Foundation

class StaticImageViewController: NSViewController, BackingView {
    
    @IBOutlet weak var timerDisplay: NSTextField!
    
// MARK: - BackingView protocol
    var pluginView: NSView {
        return view
    }
    var pluginType: BackingViewType {
        return .staticImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
    }
    
	func update(duration: TimeInterval, remaining: TimeInterval) {
        updateDisplay(time: remaining)
	}
    
    let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH'-'mm'-'ss")
        return formatter
    }()
    
    var limit: TimeInterval {
        return UserDefaults.standard.double(forKey: OwlTimerDefaults.warningLimitSeconds)
    }
    
    func updateDisplay(time remaining: TimeInterval) {
        let text = formatter.string(from:  Date(timeIntervalSinceReferenceDate: remaining))
        timerDisplay.stringValue = text
        if remaining > 0, remaining < limit {
            timerDisplay.textColor = .red
        } else {
            timerDisplay.textColor = .white
        }
    }
    
    func configureTextField() {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.7)
        shadow.shadowOffset = NSSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 3
        timerDisplay.shadow = shadow
    }
}
