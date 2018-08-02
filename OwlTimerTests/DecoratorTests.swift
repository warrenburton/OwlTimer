//
//  DecoratorTests.swift
//  OwlTimerTests
//
//  Created by Warren Burton on 01/08/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import OwlTimer

private class ColorStub: TextColor {
    var textColor: NSColor?
}

class TextDecoratorTests: QuickSpec {
    override func spec() {
        it("should alter the color when time is less than limit") {
            let decorator = ColorWhenLessThanDecorator(limit: 20, color: .blue)
            let stub = ColorStub()
            decorator.decorate(text: stub, remainingTime: 18)
            expect(stub.textColor).to(equal(.blue))
        }
        
        it("should not alter the color when time is greater than limit") {
            let decorator = ColorWhenLessThanDecorator(limit: 20, color: .blue)
            let stub = ColorStub()
            decorator.decorate(text: stub, remainingTime: 22)
            expect(stub.textColor).to(equal(.white))
        }
    }
}
