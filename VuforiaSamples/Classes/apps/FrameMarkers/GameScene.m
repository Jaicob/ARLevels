//
//  GameScene.m
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view{
    SKSpriteNode *scoot = [SKSpriteNode spriteNodeWithImageNamed:@"scoot.png"];
    scoot.position = CGPointMake(100, 100);
    scoot.size = CGSizeMake(50, 50);
    [self addChild:scoot];
    NSLog(@"Presented Scene");
    self.backgroundColor = [UIColor clearColor];
    
    
}

@end
