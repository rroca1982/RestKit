//
//  Service.swift
//  RestKit
//
//  Created by Rodolfo Roca on 12/10/18.
//  Copyright © 2018 Rodolfo Roca. All rights reserved.
//

import Foundation

public protocol Service {
    associatedtype EndPoint: EndPointType
}

extension Service {
    public var manager: NetworkManager<EndPoint> {
        return NetworkManager<EndPoint>()
    }
    
}
