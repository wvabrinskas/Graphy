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
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func scoreLine(from: CGPoint, to: CGPoint) -> CAShapeLayer {
    let scoreLine = CGMutablePath()
    scoreLine.move(to: from)
    scoreLine.addLine(to: to)
    let scoreLayer = CAShapeLayer()
    scoreLayer.strokeColor = viewModel.gridColor?.cgColor ?? UIColor.lightGray.cgColor
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
  
  public func load() {
    self.layer.sublayers?.forEach({ (layer) in
      layer.removeFromSuperlayer()
    })
    
    let graphLayer = CALayer()
    graphLayer.backgroundColor = viewModel.backgroundColor?.cgColor ?? UIColor.black.cgColor
    graphLayer.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    
    let offsetX = viewModel.offset?.x ?? 10
    let offsetY = viewModel.offset?.y ?? 10
    
    let maxHeight = self.size.height - offsetY
    let maxWidth = self.size.width - offsetX
    
    let minX = offsetX / 2
    let maxY = offsetY / 2
    let minY = maxHeight + (offsetY / 2)
    let maxX = maxWidth + (offsetX / 2)
    
    let ySpacing = maxHeight / 110
    
    var previousPoint: CGPoint?
    
    var x = 0
    let line = CGMutablePath()
    let lineLayer = CAShapeLayer()
    let axisLineLayer = CAShapeLayer()
    
    guard let lastXPoint = self.points.last?.x else {
      return
    }
    
    for x in stride(from: minX, through: maxX, by: viewModel.axisScale?.x ?? 100) {
      let currentX = (lastXPoint / maxWidth) * (x - minX)
      
      if viewModel.showAxisLabels ?? false {
        let graphlabel = UILabel(frame: CGRect(x: x - 10, y: minY - 25, width: 50, height: 20))
        graphlabel.text = "\(Int(currentX))"
        graphlabel.sizeToFit()
        self.addSubview(graphlabel)
      }
      
      //scores
      let scoreLayer = self.scoreLine(from: CGPoint(x: x, y: maxY), to: CGPoint(x: x, y: minY))
      graphLayer.addSublayer(scoreLayer)
    }
    
    for y in stride(from: maxY, through: minY, by: viewModel.axisScale?.y ?? 100) {
      let currentY = (110 / maxHeight) * (y - minY)
      
      if viewModel.showAxisLabels ?? false {
        let graphlabel = UILabel(frame: CGRect(x: minX - 30.0, y: y - 5, width: 50, height: 20))
        graphlabel.text = "\(Int(currentY))"
        graphlabel.sizeToFit()
        self.addSubview(graphlabel)
      }
      
      let scoreYLayer = self.scoreLine(from: CGPoint(x: minX, y: y), to: CGPoint(x: maxX, y: y))
      graphLayer.addSublayer(scoreYLayer)
      
    }
    
    for point in self.points {
      
      let zoomY = viewModel.zoom?.y ?? 1
      let zoomX = viewModel.zoom?.x ?? 1
      let pointSize = viewModel.pointSize ?? CGSize(width: 5, height: 5)
      
      let currentX = ((((point.x * CGFloat(zoomX)) * maxWidth) / lastXPoint) + (offsetX / 2)) - (pointSize.width / 2)
      let currentY = minY - ((point.y * CGFloat(zoomY)) * ySpacing) - (pointSize.height / 2)
      
      
      let oval = CGPath(ellipseIn: CGRect(x: currentX,
                                          y: currentY,
                                          width: pointSize.width,
                                          height: pointSize.height),
                        transform: nil)
      let shapeLayer = CAShapeLayer()
      
      shapeLayer.fillColor = UIColor.red.cgColor
      shapeLayer.strokeColor = UIColor.clear.cgColor
      shapeLayer.path = oval
      
      graphLayer.addSublayer(shapeLayer)
      
      if let prevPoint = previousPoint {
        line.move(to:  CGPoint(x: prevPoint.x + 2.5, y: prevPoint.y + 2.5))
        line.addLine(to: CGPoint(x: currentX + 2.5, y: currentY + 2.5))
      }
      
      if viewModel.showPointLabels ?? false {
        let pointLabel = self.pointLabel(currentPoint: CGPoint(x: currentX, y: currentY), value: point)
        self.addSubview(pointLabel)
      }
    
      previousPoint = CGPoint(x: currentX, y: currentY)
      x += 1
    }
    
    lineLayer.strokeColor = viewModel.lineColor?.cgColor ?? UIColor.red.cgColor
    lineLayer.lineWidth = 2.0
    lineLayer.path = line
    lineLayer.lineCap = .round
    
    let axis = CGMutablePath()
    axis.move(to: CGPoint(x: minX, y: minY))
    axis.addLine(to: CGPoint(x: maxX, y: minY))
    axis.move(to: CGPoint(x: minX, y: minY))
    axis.addLine(to: CGPoint(x: minX, y: maxY))
    
    axisLineLayer.strokeColor = viewModel.gridColor?.cgColor ?? UIColor.lightGray.cgColor
    axisLineLayer.lineWidth = 2.5
    axisLineLayer.path = axis
    
    graphLayer.addSublayer(axisLineLayer)
    graphLayer.addSublayer(lineLayer)
    
    self.layer.addSublayer(graphLayer)
    self.layer.masksToBounds = true
  }
  
  public func update(_ model: GraphyViewModel) {
    self.viewModel.axisScale = model.axisScale
    self.viewModel.backgroundColor = model.backgroundColor
    self.viewModel.gridColor = model.gridColor
    self.viewModel.lineColor = model.lineColor
    self.viewModel.offset = model.offset
    self.viewModel.pointSize = model.pointSize
    self.viewModel.showPointLabels = model.showPointLabels
    self.viewModel.showAxisLabels = model.showAxisLabels
    
    self.load()
  }
}
