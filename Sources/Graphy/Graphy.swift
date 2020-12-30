import Foundation
import UIKit

public class Graphy: UIView {
  private var points = [CGPoint]()
  private var size: CGSize!
  
  public var viewModel: GraphyViewModel
  
  public init(points: [CGPoint], size: CGSize, viewModel: GraphyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.points = points
    self.size = size
    
    let graphLayer = CALayer()
    graphLayer.backgroundColor = UIColor.clear.cgColor
    graphLayer.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    
    let maxHeight = self.size.height - viewModel.offset.y
    let maxWidth = self.size.width - viewModel.offset.x
    
    let minX = viewModel.offset.x / 2
    let minY = viewModel.offset.y / 2
    let maxY = maxHeight + (viewModel.offset.y / 2)
    let maxX = maxWidth + (viewModel.offset.x / 2)
    
    let ySpacing = maxHeight / 110
    
    var previousPoint: CGPoint?
    
    var x = 0
    let line = CGMutablePath()
    let lineLayer = CAShapeLayer()
    let axisLineLayer = CAShapeLayer()
    
    guard let lastXPoint = self.points.last?.x else {
      return
    }
    
    for x in stride(from: minX, through: maxX, by: viewModel.axisScale.x) {
      let currentX = (lastXPoint / maxWidth) * (x - minX)
      
      if viewModel.showLabels {
        let graphlabel = UILabel(frame: CGRect(x: x - 10, y: minY - 25, width: 50, height: 20))
        graphlabel.text = "\(Int(currentX))"
        graphlabel.sizeToFit()
        self.addSubview(graphlabel)
      }
      
      //scores
      let scoreLayer = self.scoreLine(from: CGPoint(x: x, y: minY), to: CGPoint(x: x, y: maxY))
      graphLayer.addSublayer(scoreLayer)
    }
    
    for y in stride(from: minY, through: maxY, by: viewModel.axisScale.y) {
      let currentY = (110 / maxHeight) * (y - minY)
      
      if viewModel.showLabels {
        let graphlabel = UILabel(frame: CGRect(x: minX - 30.0, y: y - 5, width: 50, height: 20))
        graphlabel.text = "\(Int(currentY))"
        graphlabel.sizeToFit()
        self.addSubview(graphlabel)
      }
      
      let scoreYLayer = self.scoreLine(from: CGPoint(x: minX, y: y), to: CGPoint(x: maxX, y: y))
      graphLayer.addSublayer(scoreYLayer)
      
    }
    
    for point in self.points {
      
      let currentX = (((point.x * maxWidth) / lastXPoint) + (viewModel.offset.x / 2)) - (viewModel.pointSize.width / 2)
      let currentY = ((point.y * ySpacing) + (viewModel.offset.y / 2)) - (viewModel.pointSize.height / 2)
      
      let oval = CGPath(ellipseIn: CGRect(x:currentX,
                                          y: currentY,
                                          width: viewModel.pointSize.width,
                                          height: viewModel.pointSize.height),
                        transform: nil)
      let shapeLayer = CAShapeLayer()
      
      shapeLayer.fillColor = UIColor.red.cgColor
      shapeLayer.strokeColor = UIColor.clear.cgColor
      shapeLayer.path = oval
      
      graphLayer.addSublayer(shapeLayer)
      
      if previousPoint != nil {
        line.move(to:  CGPoint(x: previousPoint!.x + 2.5, y: previousPoint!.y + 2.5))
        line.addLine(to: CGPoint(x: currentX + 2.5, y: currentY + 2.5))
      }
      
      let pointLabel = self.pointLabel(currentPoint: CGPoint(x: currentX, y: currentY), value: point)
      self.addSubview(pointLabel)
      
      
      previousPoint = CGPoint(x: currentX, y: currentY)
      x += 1
    }
    
    lineLayer.strokeColor = UIColor.red.cgColor
    lineLayer.lineWidth = 2.0
    lineLayer.path = line
    lineLayer.lineCap = .round
    
    let axis = CGMutablePath()
    axis.move(to: CGPoint(x: minX, y: minY))
    axis.addLine(to: CGPoint(x: maxX, y: minY))
    axis.move(to: CGPoint(x: minX, y: minY))
    axis.addLine(to: CGPoint(x: minX, y: maxY))
    
    axisLineLayer.strokeColor = UIColor.lightGray.cgColor
    axisLineLayer.lineWidth = 2.5
    axisLineLayer.path = axis
    
    graphLayer.addSublayer(axisLineLayer)
    graphLayer.addSublayer(lineLayer)
    
    self.layer.addSublayer(graphLayer)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func scoreLine(from: CGPoint, to: CGPoint) -> CAShapeLayer {
    let scoreLine = CGMutablePath()
    scoreLine.move(to: from)
    scoreLine.addLine(to: to)
    let scoreLayer = CAShapeLayer()
    scoreLayer.strokeColor = UIColor.lightGray.cgColor
    scoreLayer.lineWidth = 1.0
    scoreLayer.path = scoreLine
    return scoreLayer
  }
  
  private func pointLabel(currentPoint: CGPoint, value: CGPoint) -> UILabel {
    let graphlabel = UILabel(frame: CGRect(x: currentPoint.x - 10, y: currentPoint.y - 10, width: 50, height: 20))
    graphlabel.text = "(\(Int(value.x)), \(Int(value.y))%)"
    graphlabel.sizeToFit()
    return graphlabel
  }
  
}
