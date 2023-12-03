//
//  AnyService.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation

/// Type earesed verion of Service
public struct AnyService<RequestType, ResponseType: Codable>: Service {
    public typealias Request = AnyRequest<RequestType>
    
    public typealias ResponseType = ResponseType
    
    public let request: Request
    public init(_ request: Request) {
        self.request = request
    }
}
