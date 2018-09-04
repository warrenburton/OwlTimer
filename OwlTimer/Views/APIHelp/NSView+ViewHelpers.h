//
//  NSView+ViewHelpers.h
//  DevSketch
//
//  Created by Warren Burton on 01/12/2013.
//  Copyright (c) 2013 Warren Burton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (ViewHelpers)

-(void)removeAllSubviews;
-(NSPoint)center;
+(NSPoint)pointWithCenter:(NSPoint)cen radius:(CGFloat)radius atAngle:(CGFloat)theta;
+(CGFloat)angleFrom:(CGPoint)pointA to:(CGPoint)pointB;
+(CGFloat)angleOfAttack:(NSPoint)apoint forRect:(NSRect)arect;
+(NSPoint)edgePointForAttackAngle:(CGFloat)angle inRect:(NSRect)arect;
+(NSPoint)rectCenter:(NSRect)arect;
- (void)setScale:(NSSize) newScale;
- (NSSize)scale;
- (CGFloat)scalePercent;
- (void)setScalePercent:(CGFloat) scale;
-(NSRect)validateRect:(NSRect)frame;
-(NSRect)rectWithCorner1:(NSPoint)point1 corner2:(NSPoint)point2;

@end

NS_ASSUME_NONNULL_END
