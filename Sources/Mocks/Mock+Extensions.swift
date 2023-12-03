//
//  Mock.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
public struct Mock {

}

public extension Mock {
	static func measure(_ closure: ()->Void, title: String) {
		let start = Date().timeIntervalSince1970
		closure()
		let end = Date().timeIntervalSince1970
		let ms = end - start
		printResult(finishedIn: ms, comment: title)
	}

	@discardableResult
	static func asyncMeasure<T>(_ closure: () async throws -> T, title: String) async throws  -> T{
		let start = Date().timeIntervalSince1970
		let data =  try await closure()
		let end = Date().timeIntervalSince1970
		let ms = end - start
		printResult(finishedIn: ms, comment: title)
		return data
	}
	
	static func asyncMeasure(_ closure: () async throws -> Void, title: String) async throws {
		let start = Date().timeIntervalSince1970
		try await closure()
		let end = Date().timeIntervalSince1970
		let ms = end - start
		printResult(finishedIn: ms, comment: title)
	}

	static private func printResult(finishedIn: TimeInterval, comment string: String) {
		print("@@---Measuring--> ", string, " ", finishedIn, "ms")
	}
}


