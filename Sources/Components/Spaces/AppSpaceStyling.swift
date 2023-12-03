//
//  AppSpaceStyling.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import Foundation
public protocol AppSpaceStyling {
	var horizontal: AppSpacing {get}
	var vertical: AppSpacing {get}
	var cornerRadius: AppSpacing {get}
}
