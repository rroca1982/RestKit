//
//  NetworkManager.swift
//  RestKit
//
//  Created by Rodolfo Roca on 12/11/18.
//  Copyright © 2018 Rodolfo Roca. All rights reserved.
//

import Foundation

public class NetworkManager<EndPoint: EndPointType> {
    public init(){ }
    
    public let dispatcher = Dispatcher<EndPoint>()
    
    public enum NetworkResponse: Error {
        case success
        case forbidden
        case badRequest
        case outdated
        case failed
        case notFound
        case unableToDecode
    }
    
    public func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<NetworkResponse> {
        switch response.statusCode {
            case 200...299: return .Success(NetworkResponse.success)
            case 401...403: return .Failure(NetworkResponse.forbidden)
            case 404: return .Failure(NetworkResponse.notFound)
            case 405...499: return .Failure(NetworkResponse.failed)
            case 500...599: return .Failure(NetworkResponse.badRequest)
            case 600: return .Failure(NetworkResponse.outdated)
            default: return .Failure(NetworkResponse.unableToDecode)
        }
    }
}
