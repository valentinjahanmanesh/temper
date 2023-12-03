//
//  DefaultRepository.swift
//
//
//  Created by Farshad Jahanmanesh.
//

import Foundation
import DataProvider
import Core
import Combine
import Dependencies

public class DefaultRepository: RepositoryProtocol {
	enum Request: RequestBuilder {
		enum V3 {
			static let path = "v3"
			case getShifts(filters: Dictionary<String, String>)
		}
		case v3(V3)
		static var baseURL: String {
			"https://temper.works/api"
		}

		static var defaultHeaders: [String: String] {
			var headers: [String: String] = [:]
			headers.updateValue("application/json", forKey: "accept")
			headers.updateValue("application/json", forKey: "Content-Type")
			return headers
		}

		private func simpleGet(url: URL) -> URLRequest {
			var request = URLRequest.init(url: url)
			request.httpMethod = HTTPMethod.get.rawValue
			request.timeoutInterval = 5
			request.allHTTPHeaderFields = Self.defaultHeaders
			return request
		}

		func build() -> URLRequest {
			switch self {
			case .v3(let path):
				var url: URL = URL(string: Self.baseURL)!.appendingPathComponent(V3.path)

				switch path {
				case .getShifts(let filters):
					url = url.appendingPathComponent("shifts")
					filters.forEach { key, value in
						url.appendQueryItem(name: key, value: value)
					}
				}
				return simpleGet(url: url)
			}
		}
	}

	let client: AnyAsyncProvider<AnyRequest<URLRequest>>
	let repositoryURLSession = URLSession(configuration: .default)
	let decoder: JSONDecoder
	let encoder: JSONEncoder

	public init(client: AnyAsyncProvider<AnyRequest<URLRequest>>? = nil,
				decoder: JSONDecoder = .defaultAppJSONDecoder,
				encoder: JSONEncoder = .defaultAppJSONEncoder,
				notificationCenter: NotificationCenter = .default
	) {
		URLCache.shared.memoryCapacity = 50_000_000 // ~50 MB memory space
		URLCache.shared.diskCapacity = 1_000_000_000 // ~1GB disk cache space

		self.client = client ?? APIDataProvider<AnyRequest<URLRequest>>.init(session: repositoryURLSession).eraseToAnyAsyncProvider()
		self.decoder = decoder
		self.encoder = encoder
	}

	public func getShifts(_ filters: [Core.GetShitsFilter]) async throws -> [Shift]{
		let queryParameters: Dictionary<String, String> = filters.reduce(into: .init()) { partialResult, filter in
			let param = filter.toQueryParam()
			partialResult.updateValue(param.value, forKey: param.key)
		}
		let data = try await client.runAsync(request: Self.Request.v3(.getShifts(filters: queryParameters)).asAnyRequest())
		let dto = try self.decoder.decode(ShiftsResponseDTO.self, from: data)
		return dto.data.map(\.mapToAppModel)
	}
}

public extension JSONDecoder {
	static var defaultAppJSONDecoder: JSONDecoder {
		let decoder = JSONDecoder()
		let isoFormatter  = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = isoFormatter.timeZone
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		return decoder
	}
}

public extension JSONEncoder {
	static var defaultAppJSONEncoder: JSONEncoder {
		let decoder = JSONEncoder()
		let isoFormatter  = ISO8601DateFormatter()
		isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = isoFormatter.timeZone
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		decoder.dateEncodingStrategy = .formatted(dateFormatter)
		return decoder
	}
}


private extension URL {

	mutating func appendQueryItem(name: String, value: String?) {

		guard var urlComponents = URLComponents(string: absoluteString) else { return }

		// Create array of existing query items
		var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

		// Create query item
		let queryItem = URLQueryItem(name: name, value: value)

		// Append the new query item in the existing query items array
		queryItems.append(queryItem)

		// Append updated query items array in the url component object
		urlComponents.queryItems = queryItems

		// Returns the url from new url components
		self = urlComponents.url!
	}
}
