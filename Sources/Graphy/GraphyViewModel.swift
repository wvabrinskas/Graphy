//
//  File.swift
//  
//
//  Created by William Vabrinskas on 12/30/20.
//

import Foundation
import UIKit

public struct GraphyViewModel {
  public var axisScale: CGPoint = CGPoint(x: 100.0, y: 100.0)
  public var showAxisLabels: Bool = false
  public var showPointLabels: Bool = false
  public var pointSize = CGSize(width: 5.0, height: 5.0)
  public var offset: CGPoint = CGPoint(x: 200.0, y: 200.0)
  public var zoom: CGPoint = CGPoint(x: 1.0, y: 1.0)
  public var backgroundColor: UIColor = .black
  public var lineColor: UIColor = .red
  public var gridColor: UIColor = .lightGray
  
  public init(axisScale: CGPoint = CGPoint(x: 100.0, y: 100.0),
              showAxisLabels: Bool = false,
              showPointLabels: Bool = false,
              pointSize: CGSize = CGSize(width: 5.0, height: 5.0),
              offset: CGPoint = CGPoint(x: 200.0, y: 200.0),
              zoom: CGPoint = CGPoint(x: 1.0, y: 1.0),
              backgroundColor: UIColor = .black,
              lineColor: UIColor = .red,
              gridColor: UIColor = .lightGray) {
    self.axisScale = axisScale
    self.showAxisLabels = showAxisLabels
    self.showPointLabels = showPointLabels
    self.pointSize = pointSize
    self.offset = offset
    self.zoom = zoom
    self.backgroundColor = backgroundColor
    self.lineColor = lineColor
    self.gridColor = gridColor
  }
}
