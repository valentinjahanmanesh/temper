//
//  URLSession+Extensions.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation

#if !RELEASE
public extension URLSession {
	/// Returns a local session URL, it is good for the time when we need to provide data from local JSONs,
	/// all local JSON files should be placed in the `LocalData` folder, every time a new request arrived,
	/// `LocalSession` looks at the last components of the URL and search in the JSONs (files in the LocalData)
	/// to find the corresponding JSON. the latest `Path Component` and the name of the JSON file should be equal.
    static var localSession: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [LocalURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
#endif
