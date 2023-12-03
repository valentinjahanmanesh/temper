//
//  DataProvider.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import Combine

/// Provides Data,  finds out where the data is and reads it.
/// Builds the request and  runs it on 
public protocol DataProvider {
    associatedtype Request: RequestBuilder
    func build(request: Request)-> Request.RequestType
    func run(request: Request) -> AnyPublisher<Data, ErrorType>
}
