//
//  NSView+Autolayout.h
//  DevSketch
//
//  Created by Warren Burton on 03/04/2015.
//  Copyright (c) 2015 Warren Burton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (Autolayout)

-(void)pinViewToInside:(NSView *)aview;
-(void)pinViewToSides:(NSView *)aview;

@end

NS_ASSUME_NONNULL_END
