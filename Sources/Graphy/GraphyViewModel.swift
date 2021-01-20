//
//  File.swift
//
//
//  Created by William Vabrinskas on 12/30/20.
//

import Foundation
import UIKit

@propertyWrapper
public struct Settable<T> {
  private var oldValue: T?
  public var wrappedValue: T? {
    set {
      if newValue != nil {
        oldValue = newValue
      }
    }
    get {
      return oldValue
    }
  }
  
  public init(wrappedValue: T?) {
    self.oldValue = wrappedValue
    self.wrappedValue = wrappedValue
  }
}

public struct GraphyViewModel {
  @Settable public var axisScale: CGPoint?
  @Settable public var axisDerivations: CGPoint?
  @Settable public var showAxisLabels: Bool?
  @Settable public var showPointLabels: Bool?
  @Settable public var pointSize: CGSize?
  @Settable public var offset: CGPoint?
  @Settable public var backgroundColor: UIColor?
  @Settable public var lineColor: UIColor?
  @Settable public var gridColor: UIColor?
  @Settable public var labelFontSize: CGFloat?
  @Settable public var resolution: Int?

  public init(axisScale: CGPoint? = nil,
              axisDerivations: CGPoint? = nil,
              showAxisLabels: Bool? = nil,
              showPointLabels: Bool? = nil,
              pointSize: CGSize? = nil,
              offset: CGPoint? = nil,
              backgroundColor: UIColor? = nil,
              lineColor: UIColor? = nil,
              gridColor: UIColor? = nil,
              labelFontSize: CGFloat? = nil,
              resolution: Int? = nil) {
    self.axisScale = axisScale
    self.axisDerivations = axisDerivations
    self.showAxisLabels = showAxisLabels
    self.showPointLabels = showPointLabels
    self.pointSize = pointSize
    self.offset = offset
    self.backgroundColor = backgroundColor
    self.lineColor = lineColor
    self.gridColor = gridColor
    self.labelFontSize = labelFontSize
    self.resolution = resolution
  }
}


