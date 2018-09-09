//
//  Copyright 2018 Digital-Dirtbag LTD
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


import XCTest
@testable import OwlTimer

class PieViewTests: XCTestCase {
    
    let testRect = NSRect(x: 0, y: 0, width: 100, height: 100)
    
    func validatePie(_ percentage: CGFloat) {
        let pie = PieView(frame: testRect)
        pie.percentage = percentage
        let harness = NSImage(size: testRect.size)
        harness.lockFocus()
        pie.draw(testRect)
        harness.unlockFocus()
        XCTAssert(true)
    }
    
    func testPercentageCanBeGreaterThanOne() {
        validatePie(2.0)
    }

    func testPercentageCanBeZero() {
        validatePie(0)
    }

    func testPercentageCanBeNegative() {
        validatePie(-1.0)
    }

    func testPercentageCanBeExactlyOne() {
        validatePie(1.0)
    }

}
