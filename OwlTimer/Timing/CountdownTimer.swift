//
//  Timer.swift
//  __PROJNAME__
//
//  Created by John Smith on 2018.
//  Copyright (c) 2018 WidgetSoft . All rights reserved.
//


import Foundation

///
/// Counts down time
///
class CountdownTimer: NSObject {
    private var value: TimeInterval = 0
    private var timeStrategy: TimeStrategy
    private lazy var startDate: Date = timeStrategy.now()
    
    var endAction: (()->())?
    var updateAction: ((TimeInterval)->())?
    var isActive: Bool {
        return timer != nil
    }
    
    var remainingTime: TimeInterval {
        let elapsed = timeStrategy.now().timeIntervalSince(startDate)
        let remaining = max(0, value - elapsed)
        return remaining
    }
    
    init(time: TimeInterval, timeStrategy: TimeStrategy = NormalTime() ) {
        self.value = time
        self.timeStrategy = timeStrategy
        super.init()
    }
    
    private var timer:Timer?
    func start() {
        guard !isActive else {
            return
        }
        startDate = timeStrategy.now()
        reload()
    }
    
    private func reload() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
            self?.tick()
        })
    }
    
    private func tick() {
        let elapsed = timeStrategy.now().timeIntervalSince(startDate)
        if elapsed > value {
            stop()
        } else {
            let remaining = value - elapsed
            self.updateAction?(remaining)
            reload()
        }
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        let elapsed = timeStrategy.now().timeIntervalSince(startDate)
        value -= elapsed
    }
    
    func stop() {
        guard isActive else {
            return
        }
        timer?.invalidate()
        timer = nil
        endAction?()
    }
    

    
}
