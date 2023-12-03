//
//  MockURLProtocol.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
/// Mock URL Protocol, the user needs to provide either requestHandler function or error in test cases. this can be used as URLProtocol for mocking
/// URLSession like this:
/// 
/// Example:
///
///     let configuration = URLSessionConfiguration.ephemeral
///     configuration.protocolClasses = [MockURLProtocol.self]
///     let urlSession = URLSession(configuration: configuration)
///
///
public class MockURLProtocol: URLProtocol {
    public static var error: Error?
    public static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override public  class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override public  class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override public  func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override public  func stopLoading() {
        // TODO: Andd stop loading here
    }
}
