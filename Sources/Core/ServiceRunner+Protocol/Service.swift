//
//  File.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
public protocol Service {
    associatedtype ResponseType: Codable
    associatedtype Request: RequestBuilder
    var request: Request {get}
}
