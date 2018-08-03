//
//  PresetSource.swift
//  OwlTimer
//
//  Created by Warren Burton on 02/08/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Cocoa

class PresetSource: NSObject {
    var presets: [Preset]
    
    let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH'-'mm'-'ss")
        return formatter
    }()
    
    init(presets:[Preset]) {
        self.presets = presets
        super.init()
    }
}

extension PresetSource: NSComboBoxDataSource {
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return presets.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        let preset = presets[index]
        let formattedtime = formatter.string(from:  Date(timeIntervalSinceReferenceDate: preset.duration))
        return "\(preset.name) - \(formattedtime)"
    }
}
