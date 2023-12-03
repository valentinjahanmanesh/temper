//
//  AnyProvider.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import Combine

/// Type erased version of  `DataProvider`
public struct AnyProvider<R: RequestBuilder>: DataProvider {
    private let runMethod: (R) -> AnyPublisher<Data, ErrorType>
    private let buildMethod: (R) -> R.RequestType

    public init<Provider: DataProvider>(_ provider: Provider) where Provider.Request == R {
        self.runMethod = provider.run
        self.buildMethod = provider.build
    }
    
    public func run(request: R) -> AnyPublisher<Data, ErrorType> {
        self.runMethod(request)
    }
    
    public func build(request: R) -> R.RequestType {
        self.buildMethod(request)
    }
}

public protocol AsyncDataProvider: DataProvider {
    func runAsync(request:Request) async throws -> Data
}

/// Type erased version of  `DataProvider`
public struct AnyAsyncProvider<R: RequestBuilder>: AsyncDataProvider {
    private let runAsyncMethod: (R) async throws -> Data
    private let simpleProvider: AnyProvider<R>
    public init<Provider: AsyncDataProvider>(_ provider: Provider) where Provider.Request == R {
        self.simpleProvider = .init(provider)
        self.runAsyncMethod = provider.runAsync
    }

    public func run(request: R) -> AnyPublisher<Data, ErrorType> {
        self.simpleProvider.run(request: request)
    }

    public func build(request: R) -> R.RequestType {
        self.simpleProvider.build(request: request)
    }

    public func runAsync(request: R) async throws -> Data {
        try await self.runAsyncMethod(request)
    }
}
