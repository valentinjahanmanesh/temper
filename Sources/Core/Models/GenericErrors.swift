//
//  ScreenError.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import Foundation

public struct ScreenError {
	public struct ErrorInfo {
		public let message: String
		public let type: String?
		public init(message: String, type: String?) {
			self.message = message
			self.type = type
		}
	}
	public let errors: [ErrorInfo]
	public init(errors: [ErrorInfo]) {
		self.errors = errors
	}
}
