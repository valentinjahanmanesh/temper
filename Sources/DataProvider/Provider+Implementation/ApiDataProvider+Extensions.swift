//
//  ApiDataProvider+Extensions.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import Core
public extension APIDataProvider {
    func eraseToAnyProvider<T>() -> AnyProvider<AnyRequest<T>> where AnyRequest<T> == R {
        AnyProvider(self)
    }

    func eraseToAnyAsyncProvider<T>() -> AnyAsyncProvider<AnyRequest<T>> where AnyRequest<T> == R {
        AnyAsyncProvider(self)
    }
}
