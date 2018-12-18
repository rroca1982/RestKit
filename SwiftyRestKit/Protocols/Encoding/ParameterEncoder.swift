//
//  ParameterEncoder.swift
//  SwiftyRestKit
//
//  Created by Rodolfo Roca on 12/10/18.
//  Copyright © 2018 Rodolfo Roca. All rights reserved.
//

import Foundation

public typealias Parameters = [String : Any]

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
