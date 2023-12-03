//
//  MockRequestBuilder.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//
import Foundation
import Core

public enum MockRequestBuilder: String, RequestBuilder {
    public func build() -> String {
        self.rawValue
    }
    
    case cities
    case mockKey1 = "mock_key_1"
}

public enum MockURLRequestBuilder: String, RequestBuilder {
    case cities
    
    public func build() -> URLRequest {
        URLRequest(url:  URL(string: "https://127.0.0.1/\(self.rawValue)")!)
    }
}

public extension MockURLRequestBuilder {
    /// In case we need to change our provider from web to storage or vice versa, we need to define them like this
    ///
    /// - returns:
    ///     a type erased request of the fine type
    func asUrlRequest() -> AnyRequest<URLRequest> {
        return AnyRequest(self)
    }
}

