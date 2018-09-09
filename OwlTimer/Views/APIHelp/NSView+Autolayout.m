//
//  NSView+Autolayout.m
//  DevSketch
//
//  Created by Warren Burton on 03/04/2015.
//  Copyright (c) 2015 Warren Burton. All rights reserved.
//

#import "NSView+Autolayout.h"

@implementation NSView (Autolayout)

-(void)pinViewToInside:(NSView *)aview {
    NSAssert(aview.superview, @"You must place in superview before calling this method");
    aview.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0 metrics:nil views:@{@"view" :aview}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view" :aview}]];
}

-(void)pinViewToSides:(NSView *)aview {
    NSAssert(aview.superview, @"You must place in superview before calling this method");
    aview.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0 metrics:nil views:@{@"view" :aview}]];
}

@end
