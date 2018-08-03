//
//  ViewController.swift
//  OwlTimer
//
//  Created by Warren Burton on 29/07/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa

class TimerViewController: NSViewController, TimerStateTracking {
    
    private var downstreamTrackers = [TimerStateTracking]()
    var state: TimerState = .stopped {
        didSet {
            validateDisplay()
            for tracker in downstreamTrackers {
                tracker.state = state
            }
        }
    }
    
    @IBOutlet weak var timerDisplay: NSTextField!
    @IBOutlet weak var controlPanel: NSView!
    @IBOutlet weak var controlLayer: NSView!
    
    var trackingRectTag: NSView.TrackingRectTag?
    var timerStartValue: TimeInterval = 0
    let decorator: LabelDecorator = ColorWhenLessThanDecorator(limit: 50, color: .red)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        state = .stopped
        configureTextField()
        configureControlLayer()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let settings = segue.destinationController as? SettingsController {
            settings.delegate = self
        }
        if let tracker = segue.destinationController as? TimerStateTracking {
            downstreamTrackers.append(tracker)
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if trackingRectTag == nil {
            trackingRectTag = view.addTrackingRect(view.bounds, owner: self, userData: nil, assumeInside: false)
        }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        if let tag = trackingRectTag  {
            view.removeTrackingRect(tag)
            trackingRectTag = nil
        }
    }
    
    func configureControlLayer() {
        controlLayer.wantsLayer = true
        controlLayer.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.8).cgColor
        controlLayer.layer?.cornerRadius = 5
    }
    
    func configureTextField() {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.7)
        shadow.shadowOffset = NSSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 3
        timerDisplay.shadow = shadow
    }
    
    func validateDisplay() {
        switch state {
        case .stopped:
            updateDisplay(time: 0)
            self.view.window?.level = .normal
        case .paused:
            self.view.window?.level = .normal
        case .running:
            self.view.window?.level = .floating
        }
    }
    
    
    var timer : CountdownTimer?
    
    func gotoRunningState() {
        timer?.start()
        state = .running
    }
    
    func gotoPausedState() {
        timer?.pause()
        state = .paused
    }
    
    func startTimer() {
        guard timer == nil else {
            return
        }
        guard timerStartValue > 0 else {
            return
        }
        timer = CountdownTimer(time: timerStartValue)
        timer?.updateAction = { remaining in
            self.updateDisplay(time: remaining)
        }
        timer?.endAction = {
            NSSound.beep()
            self.resetTimer()
        }
        gotoRunningState()
    }
    
    func updateDisplay(time remaining: TimeInterval) {
        let text = formatter.string(from:  Date(timeIntervalSinceReferenceDate: remaining))
        timerDisplay.stringValue = text
        decorator.decorate(text: timerDisplay, remainingTime: remaining)
    }
    
    let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH'-'mm'-'ss")
        return formatter
    }()
    
    var mouseInside = true
    override func mouseEntered(with event: NSEvent) {
        mouseInside = true
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 1.0
            controlPanel.animator().alphaValue = 1.0
        })
    }
    
    override func mouseExited(with event: NSEvent) {
        mouseInside = false
        let deadline =  DispatchTime.now().uptimeNanoseconds +  UInt64(3.0) * NSEC_PER_SEC
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds:deadline)) {
            
            let allowHiding = self.mouseInside == false && self.state == .running
            guard allowHiding else { return }
            
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 1.0
                self.controlPanel.animator().alphaValue = 0
            })
        }
    }
    
}

extension TimerViewController: SettingsDelegate {
    
    func updateTimeRemaining(time: TimeInterval) {
        timerStartValue = time
    }
    
    func startStopTimer() {
        if timer != nil {
            if state == .paused {
                gotoRunningState()
            } else {
                gotoPausedState()
            }
        }
        else {
            startTimer()
        }
    }
    
    func resetTimer() {
        timer?.stop()
        timer = nil
        updateDisplay(time: 0)
        state = .stopped
    }
    
    func updateStartValue(_ value: TimeInterval ) {
        timerStartValue = value
    }
    
}
