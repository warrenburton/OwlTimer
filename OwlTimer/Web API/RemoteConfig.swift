//
//  RemoteConfig.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import Foundation

class RemoteConfig: NSObject {
    
    static var shared: RemoteConfig = RemoteConfig()
    
    private var httpProtocol = "http://"
    private var hostname: String = "localhost:4567"
	var presetAPI: URL {
        let api = "/presets"
        return composeAPI(endpoint: api)
    }
    
    private func composeAPI( endpoint: String) -> URL {
        guard !endpoint.isEmpty else {
            fatalError("empty endpoint?")
        }
        let composedEndpoint = "\(httpProtocol)\(hostname)\(endpoint)"
        guard let url = URL(string: composedEndpoint) else {
            fatalError("unable to create URL for endpoint of [\(composedEndpoint)]")
        }
        return url
    }
    
}
