//
//  Copyright 2018 Digital-Dirtbag LTD
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


import AppKit
import Foundation

class StaticImageViewController: NSViewController, RenderView {
    
    var renderType: RenderViewType { return .staticImage }
    var renderView: NSView { return view }
    
    
    @IBOutlet weak var timerDisplay: NSTextField!
    
    func updateDisplay(time remaining: TimeInterval) {
        let text = formatter.string(from:  Date(timeIntervalSinceReferenceDate: remaining))
        timerDisplay.stringValue = text
        if remaining > 0, remaining < 50 {
            timerDisplay.textColor = .red
        } else {
            timerDisplay.textColor = .white
        }
    }
    
    func configureTextField() {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.7)
        shadow.shadowOffset = NSSize(width: 2, height: 2)
        shadow.shadowBlurRadius = 3
        timerDisplay.shadow = shadow
    }
    
    let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH'-'mm'-'ss")
        return formatter
    }()
    
    
}
