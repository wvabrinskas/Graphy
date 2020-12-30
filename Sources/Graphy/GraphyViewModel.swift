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
  public var showLabels: Bool = false
  public var pointSize = CGSize(width: 5.0, height: 5.0)
  public var offset: CGPoint = CGPoint(x: 200.0, y: 200.0)
  public var zoom: CGPoint = CGPoint(x: 1.0, y: 1.0)
  
  public init(axisScale: CGPoint = CGPoint(x: 100.0, y: 100.0),
              showLabels: Bool = false,
              pointSize: CGSize = CGSize(width: 5.0, height: 5.0),
              offset: CGPoint = CGPoint(x: 200.0, y: 200.0),
              zoom: CGPoint = CGPoint(x: 1.0, y: 1.0)) {
    self.axisScale = axisScale
    self.showLabels = showLabels
    self.pointSize = pointSize
    self.offset = offset
    self.zoom = zoom
  }
}
