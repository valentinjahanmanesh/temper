//
//  ServiceRunner.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import Combine

public protocol ServiceRunner {
    associatedtype Provider: DataProvider
    var provider: Provider {get}
    func run<A: Service>(_ action: A) -> AnyPublisher<A.ResponseType, ErrorType> where A.Request == Provider.Request
    
}
