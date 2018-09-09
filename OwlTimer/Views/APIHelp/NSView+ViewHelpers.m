//
//  NSView+ViewHelpers.m
//  DevSketch
//
//  Created by Warren Burton on 01/12/2013.
//  Copyright (c) 2013 Warren Burton. All rights reserved.
//

#import "NSView+ViewHelpers.h"

static CGFloat PI = 3.14159;
const NSSize unitSize = {
    1.0, 1.0
};

typedef NS_ENUM (NSInteger, DDRectQuadrant) {
    TopQuad,
    RightQuad,
    BottomQuad,
    LeftQuad,
};

@implementation NSView (ViewHelpers)

-(void)removeAllSubviews {
    NSArray *subviews = [[self subviews] copy];
    for (NSView *view in subviews) {
        [view removeFromSuperview];
    }
}

-(NSPoint)center {
    NSRect frame = self.frame;
    return NSMakePoint(NSMidX(frame), NSMidY(frame));
}

+(CGFloat)angleFrom:(CGPoint)pointA to:(CGPoint)pointB {
    CGFloat deltax = pointA.x - pointB.x;
    CGFloat deltay = pointA.y - pointB.y;
    if (fabs(deltax) < 0.001) {
        deltax = 0.001;
    }
    CGFloat angle = atan(deltay/fabs(deltax))*180.0/PI;
    angle = (deltax < 0) ? 180-angle : angle;
    return angle;
}

+(NSPoint)edgePointForAttackAngle:(CGFloat)angle inRect:(NSRect)arect {
    DDRectQuadrant quad = [self quadForAttackAngle:angle inRect:arect];
    
    CGFloat anglerad = angle*PI/180;
    NSPoint rectCenter = [self rectCenter:arect];
    
    if (quad == TopQuad || quad == BottomQuad) {
        CGFloat opposite = NSHeight(arect)/2;
        CGFloat adjacent = opposite*tan(anglerad);
        
        opposite *= (quad == TopQuad) ? 1 : -1;
        adjacent *= (quad == TopQuad) ? 1 : -1;
        
        return NSMakePoint(rectCenter.x + adjacent, rectCenter.y + opposite);
    }
    else {
        CGFloat adjacent = NSWidth(arect)/2;
        CGFloat opposite = adjacent/tan(anglerad);
        if (isinf(opposite)) opposite = 0;
        
        adjacent *= (quad == RightQuad) ? 1 : -1;
        opposite *= (quad == RightQuad) ? 1 : -1;
        
        return NSMakePoint(rectCenter.x + adjacent, rectCenter.y + opposite);
    }
}

+(DDRectQuadrant)quadForAttackAngle:(CGFloat)attackangle inRect:(NSRect)arect {
    CGFloat changeover = [self changeoverAngleForRect:arect];
    CGFloat lowerangle = (changeover + 2*(90-changeover));
    if (attackangle > (360 - changeover) || attackangle < changeover) {
        return TopQuad;
    }
    else if (attackangle > changeover && attackangle < lowerangle) {
        return RightQuad;
    }
    else if (attackangle > lowerangle && attackangle < (changeover + 180)) {
        return BottomQuad;
    }
    else {
        return LeftQuad;
    }
}

+(CGFloat)changeoverAngleForRect:(NSRect)rect {
    return [self angleOfAttack:NSMakePoint(NSMaxX(rect), NSMaxY(rect)) forRect:rect];
}

+(CGFloat)angleOfAttack:(NSPoint)apoint forRect:(NSRect)arect {
    NSPoint rcenter = [self rectCenter:arect];
    CGFloat deltax = apoint.x - rcenter.x;
    CGFloat deltay = apoint.y - rcenter.y;
    if (deltay == 0) {
        return deltax > 0 ? 90 : 270;
    }
    CGFloat rawangle = atan(deltax/deltay);
    if (isinf(rawangle)) rawangle = 0;
    if (deltay < 0) {
        rawangle += PI;
    }
    else if (deltax < 0) {
        rawangle += 2*PI;
    }
    CGFloat angledeg = rawangle * 180/PI;
    return angledeg;
}

//angle in degrees
+(NSPoint)pointWithCenter:(NSPoint)cen radius:(CGFloat)radius atAngle:(CGFloat)theta {
    CGFloat deltax = radius*cosf((theta * PI)/180);
    CGFloat deltay = radius*sinf((theta * PI)/180);
    CGPoint newp = CGPointMake(cen.x + deltax, cen.y + deltay);
    return newp;
}

+(NSPoint)rectCenter:(NSRect)arect {
    return NSMakePoint(NSMidX(arect), NSMidY(arect));
}

-(void)resetScaling {
    [self scaleUnitSquareToSize:[self convertSize:unitSize fromView:nil]];
}

-(void)setScale:(NSSize)newScale {
    [self resetScaling];
    [self scaleUnitSquareToSize:newScale];
}

-(NSSize)scale {
    return [self convertSize:unitSize toView:nil];
}

-(CGFloat)scalePercent {
    return [self scale].width * 100;
}

-(void)setScalePercent:(CGFloat)scale {
    scale = scale/100.0;
    [self setScale:NSMakeSize(scale, scale)];
    [self setNeedsDisplay:YES];
}

-(NSRect)validateRect:(NSRect)frame {
    NSRect vrect = [self visibleRect];
    if (NSIntersectsRect(frame, vrect)) {
        return frame;
    }
    else {
        NSRect xrect = frame;
        if (xrect.origin.x > NSMaxX(vrect)) {
            xrect.origin.x = NSMaxX(vrect)-1;
        }
        else if (xrect.origin.x < NSMinX(vrect)) {
            xrect.origin.x = NSMinX(vrect)+1;
        }
        if (xrect.origin.y > NSMaxY(vrect)) {
            xrect.origin.y = NSMaxY(vrect)-1;
        }
        else if (xrect.origin.y < NSMinY(vrect)) {
            xrect.origin.y = NSMinY(vrect)+1;
        }
        return xrect;
    }
}

-(NSRect)rectWithCorner1:(NSPoint)point1 corner2:(NSPoint)point2 {
    CGFloat width = MAX(2, fabs(point1.x - point2.x));
    CGFloat height = MAX(2, fabs(point1.y - point2.y));
    
    CGFloat originx = MIN(point1.x, point2.x);
    CGFloat originy = MIN(point1.y, point2.y);
    
    return NSMakeRect(originx, originy, width, height);
}

@end
