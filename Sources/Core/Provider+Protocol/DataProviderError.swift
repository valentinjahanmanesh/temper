//
//  ProviderError.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation

/// Data Providing Flow's error type. It is a good convention to adds error types based on the flow
///
/// Example:
///
///     public extension ErrorType {
///          static var notFound: Self = .init(rawValue: "not found.")
///     }
///
public struct ErrorType: RawRepresentable, Swift.Error {
    public var rawValue: String
	public var code: Int?
	public var error: Error?
	public var data: Data?
    public init(rawValue: String) {
        self.rawValue = rawValue
		self.error = nil
		self.data = nil
    }

	public init(rawValue: String, error: Error, data: Data?, code: Int? = nil) {
		self.rawValue = rawValue
		self.error = error
		self.data = data
		self.code = code
	}

	var localizedDescription: String {
		self.rawValue
	}
}

extension ErrorType: LocalizedError  {
	public var errorDescription: String? {
		self.rawValue
	}
}
