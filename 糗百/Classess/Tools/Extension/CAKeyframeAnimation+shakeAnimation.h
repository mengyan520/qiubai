//
//  CAKeyframeAnimation+shakeAnimation.h
//  Shake
//
//  Created by mac on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAKeyframeAnimation (shakeAnimation)

+ (CAKeyframeAnimation *)shakeAnimation:(CGRect)frame;

@end
