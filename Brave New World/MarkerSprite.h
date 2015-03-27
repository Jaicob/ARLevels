//
//  MarkerSprite.h
//  Brave New World
//
//  Created by Justin Lennox on 3/26/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "customButton.h"
@interface MarkerSprite : SKSpriteNode <SKPhysicsContactDelegate>

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *brownButtonArray;
@property (strong, nonatomic) NSMutableArray *objectsArray;

-(void)addSpritesToScene:(SKScene *)scene FromDictionary:(NSMutableDictionary *)objectDictionary;

@end
