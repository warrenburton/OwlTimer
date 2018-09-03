//
//  CountdownTimer.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import Foundation

class CountdownTimer: NSObject {

    var tickAction: ((TimeInterval,TimeInterval) -> Void)?
    var stopAction: (() -> Void)?
    
    //timing
    private var timeStrategy: TimeStrategy
    private var timer: Timer?
    var duration: TimeInterval {
        set(newDuration) {
            guard !isActive else {
                assertionFailure("attempt to set duration on running timer")
                return
            }
            timerDuration = newDuration
        }
        get {
            return timerDuration
        }
    }
    private var timerDuration: TimeInterval = 0
    private lazy var startDate: Date = timeStrategy.now()
    
    init(duration: TimeInterval, timeStrategy: TimeStrategy = RealTime()) {
        timerDuration = duration
        self.timeStrategy = timeStrategy
    }
    
    var canStart: Bool {
        return timerDuration > 0
    }
    
    var isActive: Bool {
        return timer != nil
    }
    
    var remainingTime: TimeInterval {
        let elapsed = timeStrategy.now().timeIntervalSince(startDate)
        let remaining = max(0, timerDuration - elapsed)
        return remaining
    }
    
    func start() {
        guard !isActive else {
            return
        }
        startDate = timeStrategy.now()
        reload()
    }
    
    private func reload() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.tick()
        })
    }
    
    private func tick() {
        let elapsed = timeStrategy.now().timeIntervalSince(startDate)
        if elapsed > timerDuration {
            stop()
        } else {
            let remaining = timerDuration - elapsed
            tickAction?(remaining, timerDuration)
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
        stopAction?()
    }

}
