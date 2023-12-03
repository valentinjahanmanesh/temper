//
//  AnyServiceRunner.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import Combine

/// Type earesed verion of ServiceRunner
public struct AnyServiceRunner<R>: ServiceRunner {
    public let provider: AnyProvider<AnyRequest<R>>
    private let decoder: JSONDecoder
    public init(_ provider: AnyProvider<AnyRequest<R>>, decoder: JSONDecoder = JSONDecoder()) {
        self.provider = provider
        self.decoder = decoder
    }
    
    public func run<A>(_ action: A) -> AnyPublisher<A.ResponseType, ErrorType> where A : Service, A.Request == AnyRequest<R> {
        self.provider
            .run(request: action.request.asAnyRequest())
            .decode(type: A.ResponseType.self, decoder: JSONDecoder())
            .catch({ error in
                Fail(error: .init(rawValue: error.localizedDescription))
            })
                .eraseToAnyPublisher()
    }
}
