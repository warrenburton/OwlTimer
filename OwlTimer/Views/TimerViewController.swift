//
//  ViewController.swift
//  OwlTimer
//
//  Created by Warren Burton on 29/07/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa
import Alamofire

class TimerViewController: NSViewController {
    
    enum TimerState {
        case stopped
        case paused
        case running
    }
    
    var state: TimerState = .stopped {
        didSet {
            validateDisplay()
            validateControlDisplay()
        }
    }
    
    @IBOutlet weak var timerDisplay: NSTextField!
    @IBOutlet weak var controlPanel: NSView!
    @IBOutlet weak var controlLayer: NSView!
    
    //control panel
    @IBOutlet weak var startStopButton: NSButton!
    @IBOutlet weak var presetComboBox: NSComboBox!
    @IBOutlet weak var durationPicker: NSDatePicker!
    
    //timing
    private var timer: Timer?
    private var timerDuration: TimeInterval = 0
    private lazy var startDate: Date = Date()
    
    var presets: [Preset] = [] {
        didSet {
            presetComboBox.dataSource = self
            presetComboBox.delegate = self
        }
    }
    
    var trackingRectTag: NSView.TrackingRectTag?
    
    @objc dynamic var timeRemainingAsDate: Date = Date(timeIntervalSinceReferenceDate: 0) {
        didSet {
            timerDuration = timeRemainingAsDate.timeIntervalSinceReferenceDate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .stopped
        fetchPresets()
        configureTextField()
        configureControlLayer()
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
    
    func validateControlDisplay() {
        
        var uiEnabled = true
        
        switch state {
        case .stopped:
            startStopButton.title = "Start"
        case .paused:
            startStopButton.title = "Resume"
        case.running:
            startStopButton.title = "Pause"
            uiEnabled = false
        }
        
        presetComboBox.isEnabled = uiEnabled && !presets.isEmpty
        durationPicker.isEnabled = uiEnabled
    }
    
    
    func gotoRunningState() {
        start()
        state = .running
    }
    
    func gotoPausedState() {
        pause()
        state = .paused
    }
    
    func startTimer() {
        guard timer == nil else {
            return
        }
        guard timerDuration > 0 else {
            return
        }
        gotoRunningState()
    }
    
    func updateDisplay(time remaining: TimeInterval) {
        let text = formatter.string(from:  Date(timeIntervalSinceReferenceDate: remaining))
        timerDisplay.stringValue = text
        if remaining > 0, remaining < 50 {
            timerDisplay.textColor = .red
        } else {
            timerDisplay.textColor = .white
        }
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
    
    @IBAction func resetAction(_ sender: Any) {
        resetTimer()
    }
    
    @IBAction func startStopAction(_ sender: Any) {
        startStopTimer()
    }
    
}

extension TimerViewController {
    
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
        stop()
        timer = nil
        updateDisplay(time: 0)
        state = .stopped
    }
    
}

extension TimerViewController {
    
    func fetchPresets() {
        self.presetComboBox.isEnabled = false
        let presetRequest = "http://localhost:4567/presets"
        Alamofire.request(presetRequest).responseJSON { response in
            
            guard let data = response.data else {
                print("oh no - couldnt get data?")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([Preset].self, from: data)
                self.presets =  decoded
                self.validateControlDisplay()
            } catch {
                print("oh no - couldnt decode data?")
            }
        }
    }
}

extension TimerViewController: NSComboBoxDelegate {
    func comboBoxSelectionDidChange(_ notification: Notification) {
        let preset = presets[presetComboBox.indexOfSelectedItem]
         timeRemainingAsDate = Date(timeIntervalSinceReferenceDate: preset.duration)
    }
}


extension TimerViewController: NSComboBoxDataSource {
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return presets.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        let preset = presets[index]
        let formattedtime = formatter.string(from:  Date(timeIntervalSinceReferenceDate: preset.duration))
        return "\(preset.name) - \(formattedtime)"
    }
}

extension TimerViewController { //timing
    
    var isActive: Bool {
        return timer != nil
    }
    
    var remainingTime: TimeInterval {
        let elapsed = Date().timeIntervalSince(startDate)
        let remaining = max(0, timerDuration - elapsed)
        return remaining
    }
    
    func start() {
        guard !isActive else {
            return
        }
        startDate = Date()
        reload()
    }
    
    private func reload() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
            self?.tick()
        })
    }
    
    private func tick() {
        let elapsed = Date().timeIntervalSince(startDate)
        if elapsed > timerDuration {
            stop()
        } else {
            let remaining = timerDuration - elapsed
            updateDisplay(time: remaining)
            reload()
        }
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        let elapsed = Date().timeIntervalSince(startDate)
        timerDuration -= elapsed
    }
    
    func stop() {
        guard isActive else {
            return
        }
        timer?.invalidate()
        timer = nil
        NSSound.beep()
        resetTimer()
        playSound()
    }
    
}

extension TimerViewController {
    
    func playSound() {
        if let file = Bundle.main.path(forResource: "Owl", ofType: "m4a"),
            let sound = NSSound(contentsOfFile: file, byReference: true) {
            sound.play()
        }
    }
    
}
