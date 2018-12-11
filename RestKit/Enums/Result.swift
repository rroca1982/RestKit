//
//  Result.swift
//  RestKit
//
//  Created by Rodolfo Roca on 12/11/18.
//  Copyright © 2018 Rodolfo Roca. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(T)
    case Failure(Error)
}
