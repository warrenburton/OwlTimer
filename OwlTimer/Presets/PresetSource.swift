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
        return presets[index]
    }
}
