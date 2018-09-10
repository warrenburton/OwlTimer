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
    
    //rendering
    var renderPlugin: RenderView?
    @IBOutlet weak var renderViewContainer: NSView!
    
    @IBOutlet weak var controlPanel: NSView!
    @IBOutlet weak var controlLayer: NSView!
    
    //control panel
    @IBOutlet weak var startStopButton: NSButton!
    @IBOutlet weak var presetComboBox: NSComboBox!
    @IBOutlet weak var durationPicker: NSDatePicker!
    
   //timing
    lazy var countdownTimer: CountdownTimer = {
        let timer = CountdownTimer(duration: 0)
        timer.tickAction = { [weak self] remaining, duration in
            guard let `self` = self else { return }
            self.updateDisplay(time: remaining)
        }
        timer.stopAction = { [weak self] in
            guard let `self` = self else { return }
            self.playSound()
            self.resetTimer()
        }
        return timer
    }()
    
    var presets: [Preset] = [] {
        didSet {
            presetComboBox.dataSource = self
            presetComboBox.delegate = self
        }
    }
    
    var trackingRectTag: NSView.TrackingRectTag?
    
    @objc dynamic var timeRemainingAsDate: Date = Date(timeIntervalSinceReferenceDate: 0) {
        didSet {
            countdownTimer.timerDuration = timeRemainingAsDate.timeIntervalSinceReferenceDate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .stopped
        fetchPresets()
        configureControlLayer()
        restoreRenderView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        if trackingRectTag == nil {
            trackingRectTag = view.addTrackingRect(view.bounds, owner: self, userData: nil, assumeInside: false)
        }
        view.window?.hasShadow = false
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
    
    func updateDisplay(time remaining: TimeInterval) {
        renderPlugin?.update(duration: countdownTimer.timerDuration, remaining: remaining)
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
        countdownTimer.start()
        state = .running
    }
    
    func gotoPausedState() {
        pause()
        state = .paused
    }
    
    func startTimer() {
        guard countdownTimer.canStart else {
            return
        }
        gotoRunningState()
    }
    
    
    
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
    
    lazy var formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH'-'mm'-'ss")
        return formatter
    }()
    
    
}

extension TimerViewController {
    func restoreRenderView() {
        let current = UserDefaults.standard.object(forKey: OwlTimerDefaults.currentRenderView) as? String
        installRenderPlugin(named: current)
    }
    
    func installRenderPlugin(named: String?) {
        
        let plugin: RenderView
        if let key = named, let type = RenderViewType(rawValue: key) {
            plugin = RenderViewFactory.renderer(type: type)
        } else {
            plugin = RenderViewFactory.defaultPlugin()
        }
        renderPlugin = plugin
        renderViewContainer.removeAllSubviews()
        renderViewContainer.addSubview(plugin.renderView)
        renderViewContainer.pinViewTo(inside: plugin.renderView)
    }
}

extension TimerViewController {
    
    func startStopTimer() {
        if countdownTimer.isActive {
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
        countdownTimer.stop()
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



extension TimerViewController {
    
    func playSound() {
        if let file = Bundle.main.path(forResource: "Owl", ofType: "m4a"),
            let sound = NSSound(contentsOfFile: file, byReference: true) {
            sound.play()
        }
    }
    
}


extension TimerViewController {
    
    @objc func selectPlugin(_ sender: Any?) {
        
        if let menuItem = sender as? NSMenuItem {
            let tag = menuItem.tag
            switch tag {
            case 0:
                installRenderPlugin(named: RenderViewType.staticImage.rawValue)
            case 1:
                installRenderPlugin(named: RenderViewType.pieChart.rawValue)
            default:
                assertionFailure("unhandled menu tag = \(tag) , dont expand this switch/tag combo - move to a better abstraction")
            }
        }
        
    }
}
