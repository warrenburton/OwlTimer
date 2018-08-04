//
//  SettingsController.swift
//  OwlTimer
//
//  Created by Warren Burton on 31/07/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa

protocol SettingsDelegate: class {
    func startStopTimer()
    func resetTimer()
    func updateTimeRemaining(time: TimeInterval)
}

class SettingsController: NSViewController, TimerStateTracking {
    
    weak var delegate: SettingsDelegate?
    
    @IBOutlet weak var startStopButton: NSButton!
    @IBOutlet weak var presetComboBox: NSComboBox!
    @IBOutlet weak var durationPicker: NSDatePicker!
    
    var presetSource: PresetSource? {
        didSet {
            presetComboBox.dataSource = presetSource
            presetComboBox.delegate = self
        }
    }
    @objc dynamic var timeRemainingAsDate: Date = Date(timeIntervalSinceReferenceDate: 0) {
        didSet {
            delegate?.updateTimeRemaining(time: timeRemainingAsDate.timeIntervalSinceReferenceDate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPresets()
        state = .stopped
    }
    
    func loadPresets() {
        presetComboBox.isEnabled = false
        ServiceFactory().presetQueryService.fetchPresets { (error, source) in
            if let source = source {
                self.presetComboBox.isEnabled = true
                self.presetSource = source
            }
        }
    }
    
    var state: TimerState = .stopped {
        didSet {
            validateDisplay()
        }
    }
    
    func validateDisplay() {
        
        var uiEnabled = true
        
        switch state {
        case .stopped:
            startStopButton.title = NSLocalizedString("Start", comment: "")
        case .paused:
            startStopButton.title = NSLocalizedString("Resume", comment: "")
        case.running:
            startStopButton.title = NSLocalizedString("Pause", comment: "")
            uiEnabled = false
        }
        
        presetComboBox.isEnabled = uiEnabled && presetSource != nil
        durationPicker.isEnabled = uiEnabled
    }
    
    @IBAction func resetAction(_ sender: Any) {
        delegate?.resetTimer()
    }
    
    @IBAction func startStopAction(_ sender: Any) {
        delegate?.startStopTimer()
    }
    
}

extension SettingsController: NSComboBoxDelegate {
    func comboBoxSelectionDidChange(_ notification: Notification) {
        if let preset = presetSource?.presets[presetComboBox.indexOfSelectedItem] {
            timeRemainingAsDate = Date(timeIntervalSinceReferenceDate: preset.duration)
        }
    }
}
