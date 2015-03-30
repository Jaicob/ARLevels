//
//  SpriteManager.h
//  Brave New World
//
//  Created by Justin Lennox on 3/30/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface SpriteManager : SKSpriteNode <SKPhysicsContactDelegate>


@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *brownButtonArray;
@property (strong, nonatomic) NSMutableArray *objectsArray;
@property (strong, nonatomic) NSMutableDictionary *spriteDictionary;

-(void)addSpritesToScene:(SKScene *)scene FromDictionary:(NSMutableDictionary *)objectDictionary;

@end
