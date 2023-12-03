//
//  DateDisplay.swift
//
//
//  Created by Farshad Jahanmanesh.
//

import Foundation

public struct DateDisplay: Equatable, Identifiable {
	public var id: Date {
		date
	}
	public let date: Date
	private var dateFormatter: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.doesRelativeDateFormatting = true
		return dateFormatter
	}

	// Default format
	public var display: String {
		return dateFormatter.string(from: self.date)
	}

	public var onlyTime: String {
		return display(format:  "HH:mm")
	}

	public func display(format: String = "d.M.yyyy HH:mm") -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		return dateFormatter.string(from: self.date)
	}

	public init(date: Date) {
		self.date = date
	}
}

public extension Date {
	var dateDisplay: DateDisplay {
		return DateDisplay(date: self)
	}

	#if DEBUG
	static var fixedDate: Date {
		let isoDate = "2023-12-03T19:00:00+01:00"
		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone]
		return formatter.date(from: isoDate)!
	}
	#endif
}

