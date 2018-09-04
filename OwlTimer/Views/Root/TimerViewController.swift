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
            controls?.validateControlDisplay(state)
        }
    }
    
    @IBOutlet weak var backingViewContainer: NSView!
    var backingViewPlugin: BackingView?
    
    @IBOutlet weak var controlPanel: NSView!
    var controls: ControlPanelViewController?
    lazy var timer: CountdownTimer =  {
        
        let timer = CountdownTimer(duration: 0)
        timer.tickAction = { [weak self] remaining, duration in
            guard let `self` = self else { return }
            self.backingViewPlugin?.update(duration: duration, remaining: remaining)
        }
        timer.stopAction = { [weak self] in
            guard let `self` = self else { return }
            self.playSound()
            self.resetTimer()
        }
        return timer
    }()
    
    var trackingRectTag: NSView.TrackingRectTag?
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controls = segue.destinationController as? ControlPanelViewController {
            controls.delegate = self
            self.controls = controls
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .stopped
        fetchPresets()
        restoreBackingView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.redrawShadow()
    }
    
    fileprivate func saveBackingViewPreference() {
        if let plugin = backingViewPlugin {
            let current = plugin.pluginType.rawValue
            UserDefaults.standard.set(current , forKey: OwlTimerDefaults.currentBackingView)
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        saveBackingViewPreference()
    }
    
    func restoreBackingView() {
        let current = UserDefaults.standard.object(forKey: OwlTimerDefaults.currentBackingView) as? String
        installBackingPlugin(named: current)
    }
    
    func installBackingPlugin(named: String?) {
        
        let backingView: BackingView
        if let key = named, let type = BackingViewType(rawValue: key) {
            backingView = BackingViewFactory.view(ofType: type)
        } else {
            backingView = BackingViewFactory.defaultPlugin()
        }
        backingViewPlugin = backingView
        backingViewContainer.removeAllSubviews()
        backingViewContainer.addSubview(backingView.pluginView)
        backingViewContainer.pinViewTo(inside: backingView.pluginView)
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
    
    func validateDisplay() {
        switch state {
        case .stopped:
            backingViewPlugin?.update(duration: 0, remaining: 0)
            self.view.window?.level = .normal
        case .paused:
            self.view.window?.level = .normal
        case .running:
            self.view.window?.level = .floating
        }
    }
    
    var mouseInside = true
    override func mouseEntered(with event: NSEvent) {
        mouseInside = true
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 1.0
            controlPanel.animator().alphaValue = 1.0
        }) {
            //self.view.window?.redrawShadow()
        }
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
            }) {
                //self.view.window?.redrawShadow()
            }
        }
    }
}

extension TimerViewController {
    
    @objc func selectPlugin(_ sender: Any?) {
        
        if let menuItem = sender as? NSMenuItem {
            let tag = menuItem.tag
            switch tag {
            case 0:
                installBackingPlugin(named: BackingViewType.staticImage.rawValue)
            case 1:
                installBackingPlugin(named: BackingViewType.pieChart.rawValue)
            default:
                assertionFailure("unhandled menu tag = \(tag)")
            }
        }
        
    }
}

extension TimerViewController: ControlPanelDelegate {
    func durationDidChange(_ duration: TimeInterval) {
        timer.duration = duration
    }
    
    func timerShouldStartStop() {
        startStopTimer()
    }
    
    func timerShouldReset() {
        resetTimer()
    }
    
}

extension TimerViewController {
    
    func gotoRunningState() {
        timer.start()
        state = .running
    }
    
    func gotoPausedState() {
        timer.pause()
        state = .paused
    }
    
    func startTimer() {
        guard timer.canStart else {
            return
        }
        gotoRunningState()
    }
    
    func startStopTimer() {
        if timer.isActive {
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
        timer.stop()
        backingViewPlugin?.update(duration: 0, remaining: 0)
        state = .stopped
    }
    
}

extension TimerViewController {
    
    func fetchPresets() {
        let presetRequest = "http://localhost:4567/presets"
        Alamofire.request(presetRequest).responseJSON { response in
            
            guard let data = response.data else {
                print("oh no - couldnt get data? - is sinatra singing?")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([Preset].self, from: data)
                self.controls?.presets =  decoded
                self.controls?.validateControlDisplay(self.state)
            } catch {
                print("oh no - couldnt decode data?")
            }
        }
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
