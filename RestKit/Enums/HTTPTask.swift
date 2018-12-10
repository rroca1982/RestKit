//
//  HTTPTask.swift
//  RestKit
//
//  Created by Rodolfo Roca on 12/10/18.
//  Copyright © 2018 Rodolfo Roca. All rights reserved.
//

import Foundation

public typealias HTTPHeader = [String : String]

public enum HTTPTask {
    case request
    case requestWith(bodyParameters: Parameters?, urlParameters: Parameters?)
    case requestWith(bodyParameters: Parameters?, urlParameters: Parameters?, additionalHeaders: HTTPHeader?)
    
}
