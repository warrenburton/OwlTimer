//
//  LabelDecorator.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import Cocoa

@objc protocol TextColor: class {
    var textColor: NSColor? { get set }
}

protocol LabelDecorator {
    func decorate(text: TextColor, remainingTime: TimeInterval)
}
