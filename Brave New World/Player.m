//
//  Player.m
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "Player.h"

@implementation Player
//1
//- (instancetype)initWithImageNamed:(NSString *)name
//{
//    if (self == [super initWithImageNamed:name]) {
//        self.velocity = CGPointMake(0.0, 0.0);
//    }
//    return self;
//}
//
//- (void)update:(NSTimeInterval)delta
//{
//    CGPoint gravity = CGPointMake(-450.0, 0.0);
//    CGPoint gravityStep = CGPointMultiplyScalar(gravity, delta);
//    //1
//    CGPoint forwardMove = CGPointMake(0.0, 800.0);
//    CGPoint forwardMoveStep = CGPointMultiplyScalar(forwardMove, delta);
//    
//    self.velocity = CGPointAdd(self.velocity, gravityStep);
//    //2
//    self.velocity = CGPointMake(self.velocity.y * 0.9, self.velocity.x);
//    //3
//    CGPoint jumpForce = CGPointMake(310.0, 0.0);
//    float jumpCutoff = 150.0;
//    
//    if (self.mightAsWellJump && self.onGround) {
//        self.velocity = CGPointAdd(self.velocity, jumpForce);
//        [self runAction:[SKAction playSoundFileNamed:@"jump.wav" waitForCompletion:NO]];
//    } else if (!self.mightAsWellJump && self.velocity.x > jumpCutoff) {
//        self.velocity = CGPointMake(self.velocity.y, jumpCutoff);
//    }
//    
//    if (self.forwardMarch) {
//        self.velocity = CGPointAdd(self.velocity, forwardMoveStep);
//    }
//    //4
//    CGPoint minMovement = CGPointMake(0.0, -450);
//    CGPoint maxMovement = CGPointMake(120.0, 250.0);
//    self.velocity = CGPointMake(Clamp(self.velocity.x, minMovement.x, maxMovement.x), Clamp(self.velocity.y, minMovement.y, maxMovement.y));
//    
//    CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, delta);
//    
//    self.desiredPosition = CGPointAdd(self.position, velocityStep);
//}
//
//- (CGRect)collisionBoundingBox
//{
//    CGRect boundingBox = CGRectInset(self.frame, 2, 0);
//    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
//    return CGRectOffset(boundingBox, diff.x, diff.y);
//}
//

@end
