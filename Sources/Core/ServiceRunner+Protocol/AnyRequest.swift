//
//  AnyRequest.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation

/// Type earesed verion of Request
public struct AnyRequest<R> : RequestBuilder {
    private let buildMethod: () -> R
    public init<Builder: RequestBuilder>(_ builder: Builder) where Builder.RequestType == R {
        self.buildMethod = builder.build
    }
    
    public func build() -> R {
        self.buildMethod()
    }
}
