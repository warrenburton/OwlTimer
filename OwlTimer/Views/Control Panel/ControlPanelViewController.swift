//
//  ControlPanelViewController.swift
//  OwlTimer
//
//  Created by Warren Burton on 26/08/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa

protocol ControlPanelDelegate: class {
    func durationDidChange(_ duration: TimeInterval)
    func timerShouldStartStop()
    func timerShouldReset()
}

class ControlPanelViewController: NSViewController {
    //control panel
    @IBOutlet weak var startStopButton: NSButton!
    @IBOutlet weak var presetComboBox: NSComboBox!
    @IBOutlet weak var durationPicker: NSDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreCurrentDuration()
    }
        
    fileprivate func saveCurrentDuration() {
        let current = timeRemainingAsDate.timeIntervalSinceReferenceDate
        guard current > 0 else {
            return
        }
        UserDefaults.standard.set(current , forKey: OwlTimerDefaults.currentDuration)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        saveCurrentDuration()
    }
    
    func restoreCurrentDuration() {
        let current = UserDefaults.standard.object(forKey: OwlTimerDefaults.currentDuration) as? TimeInterval
        timeRemainingAsDate = Date(timeIntervalSinceReferenceDate: current ?? 0)
    }
    
    weak var delegate: ControlPanelDelegate?
    
    var presets: [Preset] = [] {
        didSet {
            presetComboBox.dataSource = self
            presetComboBox.delegate = self
        }
    }
    
    @objc dynamic var timeRemainingAsDate: Date = Date(timeIntervalSinceReferenceDate: 0) {
        didSet {
            delegate?.durationDidChange(timeRemainingAsDate.timeIntervalSinceReferenceDate)
        }
    }
    
    //TODO: decouple
    func validateControlDisplay(_ state: TimerViewController.TimerState) {
        
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
    
    let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH'-'mm'-'ss")
        return formatter
    }()
    
    @IBAction func resetAction(_ sender: Any) {
        delegate?.timerShouldReset()
    }
    
    @IBAction func startStopAction(_ sender: Any) {
        delegate?.timerShouldStartStop()
    }

}

extension ControlPanelViewController: NSComboBoxDataSource {
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return presets.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        let preset = presets[index]
        let formattedtime = formatter.string(from:  Date(timeIntervalSinceReferenceDate: preset.duration))
        return "\(preset.name) - \(formattedtime)"
    }
}

extension ControlPanelViewController: NSComboBoxDelegate {
    func comboBoxSelectionDidChange(_ notification: Notification) {
        let preset = presets[presetComboBox.indexOfSelectedItem]
        timeRemainingAsDate = Date(timeIntervalSinceReferenceDate: preset.duration)
    }
}
