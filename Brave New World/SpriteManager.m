//
//  SpriteManager.m
//  Brave New World
//
//  Created by Justin Lennox on 3/30/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import "SpriteManager.h"
#import "customButton.h"

@implementation SpriteManager

static const int playerHitCategory =  0x1;
static const int playerFeetCategory = 0x10;
static const int groundHitCategory =  0x100;
static const int solidHitCategory =   0x1000;
static const int winLevelCategory =   0x10000;
static const int projectileCategory = 0x100000;

-(void)addSpritesToScene:(SKScene *)skScene FromDictionary:(NSMutableDictionary *)objectDictionary{
    GameScene *scene = [[GameScene alloc] init];
    self.spriteDictionary = [[NSMutableDictionary alloc] init];
    scene = (GameScene *)skScene;
    for(NSString *key in objectDictionary){
        customButton *brownButton = [customButton buttonWithType:UIButtonTypeSystem];
        if(![key isEqualToString:@"levelTitle"]){
            CGPoint point = [[objectDictionary objectForKey:key] CGPointValue];
            [brownButton setBackgroundImage:[UIImage imageNamed:@"leftArrow.png"] forState:UIControlStateNormal];
            [brownButton setFrame:CGRectMake(point.x, point.y, 50, 50)];
            
            brownButton.markerName = key;
            [self.brownButtonArray addObject:brownButton];
        
        }
        if([key isEqualToString:@"MarkerGround0"] && [brownButton.markerName isEqualToString:@"MarkerGround0"])
        {
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"ground.png"]] size:CGSizeMake(75, 75)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = solidHitCategory;
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;
            [self checkOutOfBounds:scene withSprite:square];
            [scene addChild:square];
            [self.spriteDictionary setObject:[NSValue valueWithCGPoint:square.position] forKey:@"MarkerGround0"];
            //  [self checkOutOfBounds:square markerNumber:0];
            
        }else if([key isEqualToString:@"MarkerGround1"] && [brownButton.markerName isEqualToString:@"MarkerGround1"])
        {
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"ground.png"]] size:CGSizeMake(75, 75)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = solidHitCategory;
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;
            [self checkOutOfBounds:scene withSprite:square];
            [scene addChild:square];
            [self.spriteDictionary setObject:[NSValue valueWithCGPoint:square.position] forKey:@"MarkerGround1"];
            //[self checkOutOfBounds:square markerNumber:1];
            
        }else if([key isEqualToString:@"MarkerGround2"] && [brownButton.markerName isEqualToString:@"MarkerGround2"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"ground.png"]] size:CGSizeMake(75, 75)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = solidHitCategory;
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;
            [self checkOutOfBounds:scene withSprite:square];
            [scene addChild:square];
            [self.spriteDictionary setObject:[NSValue valueWithCGPoint:square.position] forKey:@"MarkerGround2"];
            
        }else if([key isEqualToString:@"MarkerGround3"] && [brownButton.markerName isEqualToString:@"MarkerGround3"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"ground.png"]] size:CGSizeMake(75, 75)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = solidHitCategory;
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height - 2);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height - 2)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;
            [self checkOutOfBounds:scene withSprite:square];
            [scene addChild:square];
            [self.spriteDictionary setObject:[NSValue valueWithCGPoint:square.position] forKey:@"MarkerGround3"];
            
        }
        else if([key isEqualToString:@"MarkerGold"] && [brownButton.markerName isEqualToString:@"MarkerGold"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"gold.png"]] size:CGSizeMake(50, 50)];
            square.zRotation = M_PI/2;
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.anchorPoint = CGPointMake(.5, .5);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.mass = 10;
            square.physicsBody.dynamic = NO;
            square.physicsBody.restitution = 0.0f;
            square.physicsBody.categoryBitMask = winLevelCategory;
            square.physicsBody.contactTestBitMask = playerHitCategory;
            [self checkOutOfBounds:scene withSprite:square];
            [scene addChild:square];
            [self.spriteDictionary setObject:[NSValue valueWithCGPoint:square.position] forKey:@"MarkerGold"];
            
        }else if([key isEqualToString:@"MarkerPlayerStart"] && [brownButton.markerName isEqualToString:@"MarkerPlayerStart"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            
            SKSpriteNode *scoot = [[SKSpriteNode alloc] initWithImageNamed:@"scoot.png"];
            scoot.size = CGSizeMake(50, 50);
            scoot.position = square.position;
            scoot.physicsBody.allowsRotation = NO;
            scoot.physicsBody.angularVelocity = 0.0f;
            scoot.name = @"scoot";
            scoot.physicsBody.affectedByGravity = YES;
            scoot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(48, 48)];
            scoot.physicsBody.categoryBitMask = playerHitCategory;
            scoot.physicsBody.dynamic = YES;
            SKSpriteNode *feet = [[SKSpriteNode alloc] init];
            [scoot addChild:feet];
            feet.size = CGSizeMake(20, scoot.size.height - 10);
            feet.position = CGPointMake(scoot.size.height/2  - feet.size.width/2, 0);
            feet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, scoot.size.height - 10)];
            feet.physicsBody.usesPreciseCollisionDetection = YES;
            feet.physicsBody.allowsRotation = NO;
            feet.physicsBody.angularVelocity = 0.0f;
            feet.physicsBody.dynamic = YES;
            feet.physicsBody.categoryBitMask = playerFeetCategory;
            feet.physicsBody.collisionBitMask = groundHitCategory;
            feet.physicsBody.contactTestBitMask =  groundHitCategory;
            feet.physicsBody.pinned = YES;
            scoot.physicsBody.contactTestBitMask = projectileCategory | solidHitCategory;
            scoot.physicsBody.collisionBitMask =  projectileCategory | solidHitCategory;
            scoot.physicsBody.allowsRotation = NO;
            [scoot childNodeWithName:@"feet"].physicsBody.allowsRotation = NO;
            [self checkOutOfBounds:scene withSprite:square];
            [scene addChild:scoot];
            [self.spriteDictionary setObject:[NSValue valueWithCGPoint:square.position] forKey:@"MarkerPlayerStart"];
        }else if([key isEqualToString:@"MarkerPlatform"] && [brownButton.markerName isEqualToString:@"MarkerPlatform"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"platformTexture.png"]] size:CGSizeMake(50, 50)];
            square.name = @"platform";
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            CGPoint originalPosition = CGPointMake(square.position.x, square.position.y);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = solidHitCategory;
            [self addChild:square];
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height - 2);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height - 2)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.restitution = -1.0f;
            ground.physicsBody.friction = 3.0f;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;
            SKAction *moveLeft = [SKAction moveToX:originalPosition.x - 50 duration:3.0f];
            SKAction *moveRight = [SKAction moveToX:originalPosition.x + 50 duration:3.0f];
            SKAction *backAndForth = [SKAction sequence:@[moveLeft, moveRight]];
            SKAction *platformMove = [SKAction repeatActionForever:backAndForth];
            [square runAction:platformMove];
            [scene addChild:square];
            [self checkOutOfBounds:scene withSprite:square];
            [self.spriteDictionary setObject:[NSValue valueWithCGPoint:square.position] forKey:@"MarkerPlatform"];
        }else if([key isEqualToString:@"MarkerPlatform2"] && [brownButton.markerName isEqualToString:@"MarkerPlatform2"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"platformTexture2.png"]] size:CGSizeMake(50, 50)];
            square.name = @"platform2";
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            CGPoint originalPosition = CGPointMake(square.position.x, square.position.y);
            square.anchorPoint = CGPointMake(.5, .5);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.restitution = 0.0f;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = solidHitCategory;
            square.physicsBody.collisionBitMask = solidHitCategory;
            square.physicsBody.usesPreciseCollisionDetection = YES;
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height - 2);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height - 2)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;
            SKAction *moveLeft = [SKAction moveToY:originalPosition.y - 50 duration:3.0f];
            SKAction *moveRight = [SKAction moveToY:originalPosition.y + 50 duration:3.0f];
            SKAction *backAndForth = [SKAction sequence:@[moveLeft, moveRight]];
            SKAction *platformMove = [SKAction repeatActionForever:backAndForth];
            [square runAction:platformMove];
            [scene addChild:square];
            [self checkOutOfBounds:scene withSprite:square];
            [self.spriteDictionary setObject:[NSValue valueWithCGPoint:square.position] forKey:@"MarkerPlatform2"];
        }else if([key isEqualToString:@"MarkerEnemy1"] && [brownButton.markerName isEqualToString:@"MarkerEnemy1"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"enemy1Texture.png"]] size:CGSizeMake(50, 50)];
            square.name = @"enemy1";
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.xScale = -1.0f;
            CGPoint originalPosition = CGPointMake(square.position.x, square.position.y);
            square.anchorPoint = CGPointMake(.5, .5);
            square.zRotation = M_PI/2;
            [scene addChild:square];
            [self checkOutOfBounds:scene withSprite:square];
            [self.spriteDictionary setObject:[NSValue valueWithCGPoint:square.position] forKey:@"MarkerEnemy1"];
        }
        NSLog(@"Sprite Manager:%@", self.spriteDictionary);
    }
}
-(void)checkOutOfBounds:(SKScene *)scene withSprite:(SKSpriteNode *)square{
    CGFloat minX = CGRectGetMinX(scene.frame);
    CGFloat maxX = CGRectGetMaxX(scene.frame);
    CGFloat minY = CGRectGetMinY(scene.frame);
    CGFloat maxY = CGRectGetMaxY(scene.frame);
    
    while((square.position.x < minX) || (square.position.y < minY) || (square.position.x > maxX) || (square.position.y > maxY))
    {
        if(square.position.x < minX){
            square.position = CGPointMake(CGRectGetMinX(scene.frame) + square.size.width/2, square.position.y);
        }else if(square.position.y < minY){
            square.position = CGPointMake(square.position.x, CGRectGetMinY(scene.frame) + square.size.width/2);
        }else if(square.position.x > maxX){
            square.position = CGPointMake(CGRectGetMaxX(scene.frame)- square.size.width/2, square.position.y);
        }else if(square.position.y > maxY){
            square.position = CGPointMake(square.position.x, CGRectGetMaxY(scene.frame)- square.size.width/2);
        }
    }
    
}


@end
