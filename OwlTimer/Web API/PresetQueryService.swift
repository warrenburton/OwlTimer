//
//  PresetQueryService.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import Foundation

///
/// provides interfaces for remote queries
///
protocol PresetQueryService {
	func fetchPresets(completion: @escaping (Error?, PresetSource?)->())
}
