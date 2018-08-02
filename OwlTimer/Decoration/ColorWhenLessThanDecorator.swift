//
//  ColorWhenLessThanDecorator.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import Cocoa

extension NSTextField: TextColor {
}

class ColorWhenLessThanDecorator: NSObject, LabelDecorator {
    
	var limit: TimeInterval
    var color: NSColor

    init(limit: TimeInterval, color: NSColor) {
		self.limit = limit
        self.color = color
		super.init()
	}
// MARK: - LabelDecorator protocol
    func decorate(text: TextColor, remainingTime: TimeInterval) {
        if remainingTime > 0, remainingTime < limit {
            text.textColor = color
        } else {
            text.textColor = .white
        }
    }

}
