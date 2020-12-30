import Foundation
import UIKit

public extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
}

public extension Double {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> Double {
        return Double(CGFloat(self).map(from: from, to: to))
    }
}

public extension Float {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> Float {
        return Float(CGFloat(self).map(from: from, to: to))
    }
}


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
    
    let roundedY = Double(round(value.y * 1000) / 1000)
    let roundedX = Double(round(value.x * 10) / 10)

    graphlabel.text = "(\(roundedX), \(roundedY))"
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
  
    var previousPoint: CGPoint?
    
    var x = 0
    let line = CGMutablePath()
    let lineLayer = CAShapeLayer()
    let axisLineLayer = CAShapeLayer()
    
    let scale = viewModel.axisScale ?? CGPoint(x: 1.0, y: 1.0)
    let derivations = viewModel.axisDerivations ?? CGPoint(x: 10, y: 10)

    
    let sortedX = self.points.sorted(by: { $0.x < $1.x })
    
    guard let lastXPoint = sortedX.last?.x else {
      return
    }
    
    for x in stride(from: minX, through: maxX, by: derivations.x * ((scale.x * 100) / 100)) {
      let currentX = (lastXPoint / maxWidth) * (x - minX)
      
      let showAxis = viewModel.showAxisLabels ?? false
      
      if showAxis {
        let graphlabel = UILabel(frame: CGRect(x: x - 8, y: minY + 15, width: 50, height: 20))
        
        let rounded = Float(round(currentX * 10) / 10)

        graphlabel.text = "\(rounded)"
        graphlabel.sizeToFit()
        graphlabel.font = UIFont.systemFont(ofSize: viewModel.labelFontSize ?? 10)
        graphlabel.textColor = .white
        graphlabel.transform = graphlabel.transform.rotated(by: 70 * CGFloat.pi / 180)
        self.addSubview(graphlabel)
      }
      
      //scores
      let scoreLayer = self.scoreLine(from: CGPoint(x: x, y: maxY), to: CGPoint(x: x, y: minY))
      graphLayer.addSublayer(scoreLayer)
    }
    
    
    let sortedY = self.points.sorted(by: { $0.y < $1.y })
    
    guard let lastYPoint = sortedY.last?.y else {
      return
    }
    
    for y in stride(from: maxY, through: minY, by: derivations.y * ((scale.y * 100) / 100)) {
     // let currentY = (110 / maxHeight) * (minY - y)
      let currentY = (lastYPoint / maxHeight) * (y - maxY)
      //let currentY = maxHeight / (minY - y)
      
      let showAxis = viewModel.showAxisLabels ?? false

      if showAxis {
        let graphlabel = UILabel(frame: CGRect(x: minX - 40.0, y: (minY - y) - 5, width: 50, height: 20))
        let rounded = Float(round(currentY * 1000) / 1000)

        graphlabel.text = "\(rounded)"
        graphlabel.sizeToFit()
        graphlabel.font = UIFont.systemFont(ofSize: viewModel.labelFontSize ?? 10)
        graphlabel.textColor = .white
        self.addSubview(graphlabel)
      }
      
      let scoreYLayer = self.scoreLine(from: CGPoint(x: minX, y: (minY - y)), to: CGPoint(x: maxX, y: (minY - y)))
      graphLayer.addSublayer(scoreYLayer)
      
    }
    
    for point in self.points {
      
      let zoomX = ((scale.x * 100) / 100)
      let zoomY = -((scale.y * 100) / 100)

      let pointSize = viewModel.pointSize ?? CGSize(width: 5, height: 5)
      
      let currentX = (((point.x * maxWidth) / lastXPoint) + (offsetX / 2)) - (pointSize.width / 2) * zoomX
      let currentY = (minY - (((point.y * maxHeight) / lastYPoint) - (pointSize.height / 2))) * zoomY
    
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
      
      let showPoints = viewModel.showPointLabels ?? false
      
      if showPoints {
        let pointLabel = self.pointLabel(currentPoint: CGPoint(x: currentX, y: currentY), value: point)
        pointLabel.font = UIFont.systemFont(ofSize: viewModel.labelFontSize ?? 10)
        pointLabel.textColor = .white
        
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
    //self.layer.masksToBounds = true
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
    self.viewModel.labelFontSize = model.labelFontSize
    self.viewModel.axisDerivations = model.axisDerivations
    
    self.load()
  }
}
