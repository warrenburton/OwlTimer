//
//  RealTime.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import Foundation

class RealTime: NSObject, TimeStrategy {

// MARK: - TimeStrategy protocol

	func now() -> Date {
		return Date()
	}

}
