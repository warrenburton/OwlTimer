//
//  BackingViewFactory.swift
//  OwlCountdownTimer
//  
//  Created by Warren Burton on 2018.
//  Copyright (c) 2018 Digital-Dirtbag LTD . All rights reserved.
//


import Cocoa

class BackingViewFactory: NSObject {

	static func view(ofType: BackingViewType) -> BackingView  {
    
        let storyboard: NSStoryboard
        switch ofType {
        case .staticImage:
            storyboard = NSStoryboard(name: "StaticImageViewController", bundle: nil)
        case .pieChart:
            fatalError("unimplemented")
        }
        
        guard let viewController = storyboard.instantiateInitialController() as? BackingView else {
             fatalError("\(ofType) does not conform to backing view")
        }
        
        return viewController
        
	}
    
    static func defaultPlugin() -> BackingView {
        return BackingViewFactory.view(ofType: .staticImage)
    }

}
