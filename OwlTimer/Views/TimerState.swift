//
//  File.swift
//  OwlTimer
//
//  Created by Warren Burton on 03/08/2018.
//  Copyright © 2018 Warren Burton. All rights reserved.
//

import Foundation

enum TimerState {
    case stopped
    case paused
    case running
}

protocol TimerStateTracking: class {
    var state: TimerState { get set }
}
