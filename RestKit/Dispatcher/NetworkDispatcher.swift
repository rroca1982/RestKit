//
//  NetworkDispatcher.swift
//  RestKit
//
//  Created by Rodolfo Roca on 12/11/18.
//  Copyright © 2018 Rodolfo Roca. All rights reserved.
//

import Foundation

public typealias NetworkDispatcherCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkDispatcher: class {
    associatedtype EndPoint: EndPointType
    
    func request(_ route: EndPoint, completion: @escaping NetworkDispatcherCompletion)
    func cancel()
}
