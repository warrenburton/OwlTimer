
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
