//
//  TimerStrategy.swift
//  OwlTimer
//
//  Created by Warren Burton on 01/08/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Foundation

protocol TimeStrategy {
    func now() -> Date
}

class NormalTime: TimeStrategy {
    func now() -> Date {
        return Date()
    }
}
