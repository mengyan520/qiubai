//
//  CAKeyframeAnimation+shakeAnimation.m
//  Shake
//
//  Created by mac on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CAKeyframeAnimation+shakeAnimation.h"

@implementation CAKeyframeAnimation (shakeAnimation)
static int numberOfShakes = 8;//震动次数
static float durationOfShake = 0.5f;//震动时间
static float vigourOfShake = 0.02f;//震动幅度

+ (CAKeyframeAnimation *)shakeAnimation:(CGRect)frame
{
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMidX(frame), CGRectGetMidY(frame) );
	for (int index = 0; index < numberOfShakes; ++index)
	{
		CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake,CGRectGetMidY(frame));
		CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + frame.size.width * vigourOfShake,CGRectGetMidY(frame));
	}
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    CFRelease(shakePath);
    
    return shakeAnimation;
}
@end
