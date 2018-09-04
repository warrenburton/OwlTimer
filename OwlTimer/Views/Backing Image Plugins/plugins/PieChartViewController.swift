//
//  PieChartViewController.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import AppKit
import Foundation

class PieChartViewController: NSViewController, BackingView {
    
	var color: NSColor = NSColor.green.highlight(withLevel: 0.3)!
    @IBOutlet weak var timerDisplay: NSTextField!
// MARK: - BackingView protocol
	var pluginType: BackingViewType { return .pieChart }
	var pluginView: NSView { return view }
    
    @IBOutlet var pieView: PieView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
    }
    
	func update(duration: TimeInterval, remaining: TimeInterval) {
        let percentage = remaining/duration
        updateDisplay(time: remaining)
        pieView.percentage = CGFloat(percentage)
        pieView.window?.redrawShadow()
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
            pieView.pieColor = .red
        } else {
            pieView.pieColor = color
        }
    }
    
    func configureTextField() {
    
    }
    

}
