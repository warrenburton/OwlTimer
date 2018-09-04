//
//  BackingView.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import AppKit

protocol BackingView {
    var pluginType: BackingViewType { get }
    var pluginView: NSView { get }
    func update(duration: TimeInterval, remaining: TimeInterval)
}
