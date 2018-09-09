//
//  Copyright 2018 Digital-Dirtbag LTD
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


import Foundation

///
/// Counts down time to zero for a given duration
///
class CountdownTimer: NSObject {
    
    var tickAction: ((TimeInterval,TimeInterval) -> Void)?
    var stopAction: (() -> ())?

    //timing
    private var timer: Timer?
    var timerDuration: TimeInterval = 0
    private lazy var startDate: Date = timeStrategy.now()
    let timeStrategy: TimeStrategy
    init(duration: TimeInterval, timeStrategy: TimeStrategy = RealTime()) {
        self.timeStrategy = timeStrategy
        super.init()
        self.timerDuration = duration
    }

}

extension CountdownTimer { //timing
    
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
            tickAction?(remaining,timerDuration)
            reload()
        }
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        let elapsed = timeStrategy.now().timeIntervalSince(startDate)
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



