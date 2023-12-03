//
//  MockDataProvider.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import Combine
import Core

public struct MockDataProvider<R>: DataProvider where R: RequestBuilder, R.RequestType == String {
    public func runAsync(request: R) async throws -> Data {
        guard let store = store else {
            throw ErrorType.notFound
        }
        guard let data = store.get(forKey: .init(rawValue: request.build())) else { throw ErrorType.notFound }
        return data
    }
    
    public func build(request: R) -> R.RequestType {
        request.build()
    }
    
    public typealias Request = R
    public typealias Error = ErrorType
    
    private weak var store: DataStore?
    public  init(_ store: DataStore) {
        self.store = store
    }
    
    public func run(request: R) -> AnyPublisher<Data, Error> {
            guard let store = store else {return Fail(error: .notFound).eraseToAnyPublisher() }
            
            let data = store.get(forKey: .init(rawValue: request.build()))
            guard let data = data else {
                return Fail(error: .notFound).eraseToAnyPublisher()
            }
            
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        
    }
}
