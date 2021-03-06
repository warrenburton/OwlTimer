//
//  PresetQuery.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import Foundation
import Alamofire

class PresetQuery: NSObject, PresetQueryService {

// MARK: - PresetQueryService protocol

    func fetchPresets(completion: @escaping (Error?, PresetSource?)->()) {
        let presetRequest = RemoteConfig.shared.presetAPI
        Alamofire.request(presetRequest).responseJSON { response in
            
            guard let data = response.data else {
                completion(ServiceError.endpointError, nil)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([Preset].self, from: data)
                let source = PresetSource(presets: decoded)
                completion(nil, source)
            } catch {
                completion(ServiceError.decodingError, nil)
            }
            
        }
	}

}
