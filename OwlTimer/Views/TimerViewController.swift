//
//  ViewController.swift
//  OwlTimer
//
//  Created by Warren Burton on 29/07/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa

class TimerViewController: NSViewController {
    
    enum State {
        case stopped
        case paused
        case running
    }
    var state: State = .stopped {
        didSet {
            validateDisplay()
        }
    }
    
    @IBOutlet weak var timerDisplay: NSTextField!
    @IBOutlet weak var startStopButton: NSButton!
    @IBOutlet weak var controlPanel: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .stopped
        configureTextField()
        configureControlLayer()
        ServiceFactory().presetQueryService.fetchPresets { (error, presets) in
            if let presets = presets {
                print("wooo - \(presets)")
            }
        }
    }
    
    var trackingRectTag: NSView.TrackingRectTag?
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
    
    @IBOutlet weak var controlLayer: NSView!
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
            startStopButton.title = "Start"
            self.view.window?.level = .normal
        case .paused:
            startStopButton.title = "Resume"
        case.running:
            startStopButton.title = "Pause"
            self.view.window?.level = .floating
        }
    }
    
    @objc dynamic var timerStartValue: Date = Date(timeIntervalSinceReferenceDate: 0)
    
    var timer : CountdownTimer?
    @IBAction func startStopAction(_ sender: Any) {
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
    
    func gotoRunningState() {
        timer?.start()
        state = .running
    }
    
    func gotoPausedState() {
        timer?.pause()
        state = .paused
    }
    
    @IBAction func resetAction(_ sender: Any) {
        timer?.stop()
        timer = nil
        state = .stopped
    }
    
    func startTimer() {
        guard timer == nil else {
            return
        }
        let startValue = timerStartValue.timeIntervalSinceReferenceDate
        guard startValue > 0 else {
            return
        }
        timer = CountdownTimer(time: startValue)
        timer?.updateAction = { remaining in
            self.updateDisplay(time: remaining)
        }
        timer?.endAction = {
            NSSound.beep()
            self.resetAction(self)
        }
        gotoRunningState()
    }
    
    func updateDisplay(time remaining: TimeInterval) {
        let text = formatter.string(from:  Date(timeIntervalSinceReferenceDate: remaining))
        timerDisplay.stringValue = text
        ColorWhenLessThanDecorator(limit: 50, color: .red).decorate(text: timerDisplay, remainingTime: remaining)
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
            guard self.mouseInside == false else { return }
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = 1.0
                self.controlPanel.animator().alphaValue = 0
            })
        }
    }
    

}

