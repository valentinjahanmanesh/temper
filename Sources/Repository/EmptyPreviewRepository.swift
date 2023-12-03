//
//  EmptyRepository.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import Core
#if DEBUG
public struct EmptyRepository: RepositoryProtocol {
	public func getShifts(_ filters: [GetShitsFilter]) async throws -> [Shift] {
		try await Task.sleep(nanoseconds: delay)
		return .mocks
	}
	let delay: UInt64
	public init(delay: TimeInterval = .one) {
		self.delay = UInt64(delay)
	}

}

public extension Collection where Element == Shift {
	static var mocks: [Shift] {
		[
			.init(id: "1",
			   image: .init(string: "https://tmpr-photos.ams3.digitaloceanspaces.com/hero/18089.jpg")!,
			   location: .init(location: .init(latitude: 0.0, longitude: 0.0)),
			   title: "Ibis Styles Hotel Ahoy Rotterdam",
			   startAt: Date.fixedDate.dateDisplay,
			   endAt: Date.fixedDate.dateDisplay,
			   earningsPerHour: "$ 13.00", category: "Serving"),
			.init(id: "2",
			   image: .init(string: "https://tmpr-photos.ams3.digitaloceanspaces.com/hero/18089.jpg")!,
			   location: .init(location: .init(latitude: 0.0, longitude: 0.0)),
			   title: "Ibis  Rotterdam",
				  startAt: Date.fixedDate.dateDisplay,
				  endAt: Date.fixedDate.dateDisplay,
			   earningsPerHour: "$ 13.00", category: "Serving")
		]
	}
}


#endif
