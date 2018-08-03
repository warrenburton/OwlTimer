//
//  ServiceFactory.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import Foundation

enum ServiceError: Error {
    case decodingError
    case endpointError
}

///
/// vends single serving network sessions
///
class ServiceFactory: NSObject {
    var presetQueryService: PresetQueryService {
        return PresetQuery()
    }
}
