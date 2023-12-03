//
//  AppSpacing.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import Foundation

public protocol AppSpacing {
    /// Default value: horizontal: 8, vertical: 8
    var small: CGFloat {get}
    /// Default value: horizontal: 10, vertical: 16
    var medium: CGFloat {get}
    /// Default value: horizontal: 24, vertical: 24
    var large: CGFloat {get}
    /// Default value: horizontal: 32, vertical: 32
    var maxLarge: CGFloat {get}
}
