import AVFoundation
import UIKit
import Foundation
class GridView: UIView {
    
// Only override draw() if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func draw(_ rect: CGRect) {
    
    // Drawing code
    
    let borderLayer = gridLayer()
    borderLayer.path = UIBezierPath(rect: bounds).cgPath
    layer.addSublayer(borderLayer)
    
    let firstColumnPath = UIBezierPath()
    firstColumnPath.move(to: CGPoint(x: bounds.width / 3, y: 0))
    firstColumnPath.addLine(to: CGPoint(x: bounds.width / 3, y: bounds.height))
    let firstColumnLayer = gridLayer()
    firstColumnLayer.path = firstColumnPath.cgPath
    layer.addSublayer(firstColumnLayer)
    
    let secondColumnPath = UIBezierPath()
    secondColumnPath.move(to: CGPoint(x: (2 * bounds.width) / 3, y: 0))
    secondColumnPath.addLine(to: CGPoint(x: (2 * bounds.width) / 3, y: bounds.height))
    let secondColumnLayer = gridLayer()
    secondColumnLayer.path = secondColumnPath.cgPath
    layer.addSublayer(secondColumnLayer)
    
    let firstRowPath = UIBezierPath()
    firstRowPath.move(to: CGPoint(x: 0, y: bounds.height / 3))
    firstRowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 3))
    let firstRowLayer = gridLayer()
    firstRowLayer.path = firstRowPath.cgPath
    layer.addSublayer(firstRowLayer)
    
    let secondRowPath = UIBezierPath()
    secondRowPath.move(to: CGPoint(x: 0, y: ( 2 * bounds.height) / 3))
    secondRowPath.addLine(to: CGPoint(x: bounds.width, y: ( 2 * bounds.height) / 3))
    let secondRowLayer = gridLayer()
    secondRowLayer.path = secondRowPath.cgPath
    layer.addSublayer(secondRowLayer)
}
private func gridLayer() -> CAShapeLayer {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = UIColor.white.cgColor
    shapeLayer.lineDashPattern = [3, 3]
    shapeLayer.frame = bounds
    shapeLayer.fillColor = nil
    return shapeLayer
}
}
