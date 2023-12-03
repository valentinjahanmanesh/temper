//
//  MockModel.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
public struct MockModel: Codable {
    public let key: String
    public let password: String
    
    public init(
        key: String,
        password: String) {
        self.key = key
        self.password = password
    }
}
