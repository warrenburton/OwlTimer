//
//  CountdownTimerTests.swift
//  OwlTimerTests
//
//  Created by Warren Burton on 01/08/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import OwlTimer

private class TimeMachine: TimeStrategy {
    var time: Date = Date()
    
    func now() -> Date {
        return time
    }
    
    @discardableResult func advance(interval: TimeInterval) -> Self {
        time = time.addingTimeInterval(interval)
        return self
    }
    
}

class CountdownTimerTests: QuickSpec {
    override func spec() {
        
        describe("the timer updates at 0.5 second intervals") {
            
            it("should send an update action within 1 second") {
                let timer = CountdownTimer(time: 10)
                var didUpdate = false
                timer.updateAction = { remainingTime in
                    didUpdate = true
                }
                timer.start()
                expect(didUpdate).toEventually(beTrue(), timeout: 2)
            }
            
            it("should send an end action when remaining time is zero") {
                let timemachine = TimeMachine()
                let timer = CountdownTimer(time: 10, timeStrategy: timemachine)
                var didEnd = false
                timer.endAction = {
                    didEnd = true
                }
                timer.start()
                timemachine.advance(interval: 11)
                expect(didEnd).toEventually(beTrue(), timeout: 2)
            }
            
            it("should should be in a inactive state after requested time period") {
                let timemachine = TimeMachine()
                let timer = CountdownTimer(time: 100, timeStrategy: timemachine)
                timer.start()
                expect(timer.isActive).to(beTrue())
                timemachine.advance(interval: 105)
                expect(timer.isActive).toEventually(beFalse(), timeout: 1)
            }
        }
        
        it("should reflect elapsed time") {
            let timemachine = TimeMachine()
            let timer = CountdownTimer(time: 100, timeStrategy: timemachine)
            timer.start()
            timemachine.advance(interval: 10)
            expect(timer.remainingTime).to(beCloseTo(90, within: 0.1))
        }
        
        it("should never be negative") {
            let timemachine = TimeMachine()
            let timer = CountdownTimer(time: 100, timeStrategy: timemachine)
            timer.start()
            timemachine.advance(interval: 105)
            expect(timer.remainingTime).to(equal(0))
        }
        
        
        
    }
}
