//
//  Shift.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import class CoreLocation.CLLocation
import struct CoreLocation.CLLocationCoordinate2D

public struct ShiftLocation: Equatable {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.location.latitude == rhs.location.latitude &&
		lhs.location.longitude == rhs.location.longitude
	}
	public let location: CLLocationCoordinate2D
	public var distanceFromAmsterdam: String {
		let location = CLLocation(latitude: location.latitude, 
								  longitude: location.longitude)
		let defaultAmsterdamLocation = CLLocation(latitude: ShiftLocation.defaultAmsterdamLocation.location.latitude,
												  longitude: ShiftLocation.defaultAmsterdamLocation.location.longitude)
		let distance = location.distance(from: defaultAmsterdamLocation) / 1000
		return String(format: "%02.f km", distance)
	}
	public init(location: CLLocationCoordinate2D) {
		self.location = location
	}
}

public extension ShiftLocation {
	static let defaultAmsterdamLocation: Self = .init(location: .init(latitude: 52.3547418, longitude: 4.8215613))
}

public struct Shift: Identifiable, Equatable {
	public let id: String
	public let image: URL
	public let location: ShiftLocation
	public let title: String
	public let category: String
	public let startAt: DateDisplay
	public let endAt: DateDisplay
	public let earningsPerHour: String
	public init(id: String,
				image: URL,
				location: ShiftLocation,
				title: String,
				startAt: DateDisplay,
				endAt: DateDisplay,
				earningsPerHour: String,
				category: String
	) {
		self.id = id
		self.image = image
		self.location = location
		self.title = title
		self.startAt = startAt
		self.endAt = endAt
		self.earningsPerHour = earningsPerHour
		self.category = category
	}
}
