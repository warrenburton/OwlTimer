
import AppKit
import Foundation

///
/// Draws pie!
///
class PieView: NSView {
    
    var percentage: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    var pieColor: NSColor = NSColor.white.shadow(withLevel: 0.1)!
    
    override func draw(_ dirtyRect: NSRect) {
        
        NSColor.clear.set()
        bounds.fill()
        
        if percentage == 1.0 { return }
        
        let value = min(max(percentage, 0), 1.0)/2.0
        
        let radius = min(bounds.width,bounds.height)/2.0
        let center = NSPoint(x: bounds.midX, y: bounds.midY)
        
        let angle = value * 360
        let endpoint1 = NSView.point(withCenter: center, radius: radius, atAngle: angle)
        
        pieColor.set()
        
        if angle > 0 {
            let path = NSBezierPath()
            path.move(to: center)
            path.line(to: endpoint1)
            path.appendArc(withCenter: center, radius: radius, startAngle: angle, endAngle: -angle, clockwise: false)
            path.line(to: center)
            path.fill()
        } else {
            let path = NSBezierPath(ovalIn:NSRect(x: center.x - radius, y: center.y - radius, width: radius*2, height: radius*2))
            path.fill()
        }
        
        
    }
}
