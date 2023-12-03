//
//  RequestBuilder.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation

/// requestBuilder
public protocol RequestBuilder {
    associatedtype RequestType
    func build() -> RequestType
}

public extension RequestBuilder {
    func asAnyRequest() -> AnyRequest<RequestType> {
        AnyRequest(self)
    }
}
