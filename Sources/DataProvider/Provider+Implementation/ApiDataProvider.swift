//
//  APIDataProvider.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//
// I created this file just to check if the solution is scalable to all kinds of data providers such as ServerCall, Storage, Memory, Database ...
// This file demonstrates the way we can define some other implementations of our `DataProvider` protocol. This is not a full implementation of our `APIDataProvider`, I will be back and finish it at the end of the project if there is enough time remaining.


import Foundation
import Combine
import Core

/// URL and API Side error should not be important for upper levels
public extension ErrorType  {
    static let serverError: Self = ErrorType(rawValue: "Server Error")
    static let jsonDecodingFailed: Self = ErrorType(rawValue: "Json Decoding Failed")
	
}
#if DEBUG
extension URLRequest {
	var dump: String {
		guard let url = self.url else {return "NO URL"}
		return """

{
	url: \(url.description),
	method: \(self.httpMethod ?? ""),
	path: "\(url.path)",
	query: "\(url.query?.removingPercentEncoding ?? "")",
	headers: {
		\((self.allHTTPHeaderFields?.compactMap {
				"\($0.key): \"\($0.value)\""
		 } ?? [""]).joined(separator: ",\n        "))
	}
	body: {
		\(self.httpBody?.prettyPrint() ?? "data: \"No json body\"")
	}
}
"""
	}
}

extension Data {
	func prettyPrint() -> String {
		do {
			let json = try JSONSerialization.jsonObject(with: self, options: [])
			let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
			guard let jsonString = String(data: data, encoding: .utf8) else {
				return "Something went wrong when parsing the json"
			}
			return jsonString
		} catch {
			return "Something went wrong when parsing the json"
		}
	}
}
#endif
public struct APIDataProvider<R: RequestBuilder>: DataProvider, AsyncDataProvider where R.RequestType == URLRequest {

    public typealias Error = ErrorType
    public typealias Request = R

    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    public func run(request: Request) -> AnyPublisher<Data, Error> {
        let preparedRequest = request.build()
        return session.dataTaskPublisher(for: preparedRequest)
            .tryMap({ element in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    // we should handle errors and pass all the other errors which may be important for top levels like validation errors,
					throw Core.ErrorType(rawValue: Core.ErrorType.serverError.rawValue, error: Core.ErrorType.serverError, data: element.data, code: (element.response as? HTTPURLResponse)?.statusCode)
                }

                return element.data
            })
            .catch({ error in
                if let coreError = error as? Core.ErrorType {
                    return Fail<Data, ErrorType>(error: coreError)
                } else {
                    return Fail<Data, ErrorType>(error: ErrorType(rawValue: error.localizedDescription, error: error, data: nil))
                }
            })
            .eraseToAnyPublisher()
    }

    public func build(request: R) -> R.RequestType {
        request.build()
    }


    public func runAsync(request: R) async throws -> Data {
        let (data, httpResponse) = try await session.data(for: request.build())
        guard let httpResponse = httpResponse as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            // we should handle errors and pass all the other errors which may be important for top levels like validation errors,
            throw Error.serverError
        }
        return data
    }
}
