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

class PieChartViewController: NSViewController, RenderView {
    
    var color: NSColor = NSColor.green.highlight(withLevel: 0.3)!
    @IBOutlet weak var timerDisplay: NSTextField!
    // MARK: - BackingView protocol
    var renderType: RenderViewType { return .pieChart }
    var renderView: NSView { return view }
    
    @IBOutlet var pieView: PieView!
    
    func update(duration: TimeInterval, remaining: TimeInterval) {
        let percentage = remaining/duration
        updateDisplay(time: remaining)
        pieView.percentage = CGFloat(percentage)
    }
    
    let formatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("HH'-'mm'-'ss")
        return formatter
    }()
    
    var limit: TimeInterval {
        return 30 //UserDefaults.standard.double(forKey: OwlTimerDefaults.warningLimitSeconds)
    }
    
    func updateDisplay(time remaining: TimeInterval) {
        let text = formatter.string(from:  Date(timeIntervalSinceReferenceDate: remaining))
        timerDisplay.stringValue = text
        if remaining > 0, remaining < limit {
            pieView.pieColor = .red
        } else {
            pieView.pieColor = color
        }
    }
    

}
