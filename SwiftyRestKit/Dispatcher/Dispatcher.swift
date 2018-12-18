//
//  Dispatcher.swift
//  RestKit
//
//  Created by Rodolfo Roca on 12/11/18.
//  Copyright © 2018 Rodolfo Roca. All rights reserved.
//

import Foundation

public class Dispatcher<EndPoint: EndPointType>: NetworkDispatcher {
    private var task: URLSessionTask?
    
    public func routeURL(_ route: EndPoint) -> String? {
        do {
            let request = try buildRequest(from: route)
            return request.url?.absoluteString
        } catch {
            return nil
        }
    }
    
    public func request(_ route: EndPoint, completion: @escaping NetworkDispatcherCompletion) {
        
        let session = URLSession.shared
        
        do {
            let request = try buildRequest(from: route)
            
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
    public func cancel() {
        task?.cancel()
    }
    
    func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestWith(let bodyParameters, let urlParameters):
                
                try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
                
            case .requestWithHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                self.additionalHeaders(additionalHeaders, request: &request)
                try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func additionalHeaders(_ additionalHeaders: HTTPHeader?, request: inout URLRequest) {
        guard let headers = additionalHeaders else {
            return
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
