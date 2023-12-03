//
//  LocalURLProtocol.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
/// Returns a local session url, it is good for the time when we need to provide data from local jsons, all local jsons should be placed in
/// `LocalData` folder, every time a new request arrives, `LocalSession` looks at the latest comonents of the URL and search in the
/// jsons list (files in LocalData) to find the represented json. the latest `Path Component` and the name of the Json file should be equal.
/// 
/// Example:
///
///     let configuration = URLSessionConfiguration.ephemeral
///     configuration.protocolClasses = [LocalURLProtocol.self]
///     return URLSession(configuration: configuration)
///

public class LocalURLProtocol: URLProtocol {
    /// Keeps address to the folder of the json files default is `/LocalData`
    public private(set) lazy var localDataPath: String? = "/LocalData"
    
    /// sets the path of the json files, correct path format is "/foldername" like "/LocalData"
    ///
    /// - Parameter path: path
    public func setLocalData(directory path: String?) {
        self.localDataPath = path
    }
    
    /// Searches in JSON files folder. When it finds the json file, returns the conent of that file in `Data` format
    ///
    /// every time a new request arrives, `LocalSession` looks at the latest comonents of the URL and search in the
    /// jsons list (files in LocalData) to find the represented json. the latest `Path Component` and the name of the Json file should be equal.
    public func requestHandler(_ request: URLRequest) throws -> (HTTPURLResponse, Data) {
        
        guard let fileName = request.url?.lastPathComponent else {
            throw URLError(.badURL)
        }
        
        guard let resources = Bundle.main.path(forResource: fileName, ofType: "json", inDirectory: localDataPath) else {
            throw URLError(.fileDoesNotExist)
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: resources)) else {
            throw URLError(.badServerResponse)
        }
        
        return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
    }
    
    override public  class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override public  class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override public  func startLoading() {
        do {
            let (response, data) = try self.requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override public func stopLoading() {
        // TODO: And stop loading here
    }
}
