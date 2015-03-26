//
//  GameScene.m
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "GameScene.h"
#import "customButton.h"
#import <AVFoundation/AVFoundation.h>


@implementation GameScene

//bit masks
static const int playerHitCategory =  0x1;
static const int playerFeetCategory = 0x10;
static const int groundHitCategory =  0x100;
static const int solidHitCategory =   0x1000;
static const int winLevelCategory =   0x10000;
static const int projectileCategory = 0x100000;


-(void)didMoveToView:(SKView *)view{
    
    self.view.multipleTouchEnabled = YES;
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity=CGVectorMake(6, 0);
    self.backgroundColor = [UIColor whiteColor];
    
    SKTexture *backgroundTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"Background.png"]];
    self.background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:CGSizeMake(720, 420)];
    self.background.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    self.background.zRotation = M_PI/2;
    [self addChild:self.background];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BackgroundTrack" ofType:@"aif"];
    NSError *error;
    self.gameSceneLoop = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
    if (error) {
        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
    } else {
        self.gameSceneLoop.numberOfLoops = -1;
        [self.gameSceneLoop prepareToPlay];
        //[self.gameSceneLoop play];
    }
    
    self.objectsArray = [[NSMutableArray alloc]init];

    SKSpriteNode *rightArrow = [SKSpriteNode spriteNodeWithImageNamed:@"rightArrow.png"];
    rightArrow.size = CGSizeMake(75, 75);

    rightArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - rightArrow.size.width/2 - 10, rightArrow.size.height/2 + 100);
    rightArrow.name = @"rightArrow";
    rightArrow.zRotation = M_PI/2;
    rightArrow.zPosition = 5.0f;
    
    [self addChild:rightArrow];
    
    SKSpriteNode *leftArrow = [SKSpriteNode spriteNodeWithImageNamed:@"leftArrow.png"];
    leftArrow.size = CGSizeMake(75, 75);
    leftArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - leftArrow.size.width/2 - 10, rightArrow.size.height/2 + 20);
    leftArrow.zRotation = M_PI/2;
    leftArrow.name = @"leftArrow";
    leftArrow.zPosition = 5.0f;
    [self addChild:leftArrow];
    
    SKSpriteNode *upArrow = [SKSpriteNode spriteNodeWithImageNamed:@"upArrow.png"];
    upArrow.size = CGSizeMake(75, 75);
    upArrow .position = CGPointMake(CGRectGetMaxX(self.view.frame) - leftArrow.size.width/2 - 10, CGRectGetMaxY(self.view.frame) - rightArrow.size.height/2 - 10);
    upArrow.zRotation = M_PI/2;
    upArrow.name = @"upArrow";
    upArrow.zPosition = 5.0f;
    [self addChild:upArrow];
    
    self.uiView = [[UIView alloc] init];
    [self.view addSubview:self.uiView];
    
    self.brownButtonArray = [[NSMutableArray alloc] init];
    
    self.userInteractionEnabled = YES;
    NSLog(@"Dictionary: %@", self.objectInfoDictionary);
    for(NSString *key in self.objectInfoDictionary){
        CGPoint point = [[self.objectInfoDictionary objectForKey:key] CGPointValue];
        customButton *brownButton = [customButton buttonWithType:UIButtonTypeSystem];
        [brownButton setBackgroundImage:[UIImage imageNamed:@"leftArrow.png"] forState:UIControlStateNormal];
        [brownButton setFrame:CGRectMake(point.x, point.y, 50, 50)];
        [brownButton addTarget:nil action:@selector(saveBackgroundImage) forControlEvents:UIControlEventTouchDown];
        
        brownButton.markerName = key;
        [self.brownButtonArray addObject:brownButton];
        //NSLog(@"x: %f, y: %f", (point.x/1334)*568, (point.y/750)*320);
        CGPoint pointFlipped = CGPointMake((point.x/1334)*568, (point.y/750)*320);
        CGPoint finalPoint = CGPointMake(pointFlipped.y, pointFlipped.x);
        

        if([key isEqualToString:@"MarkerGround0"] && [brownButton.markerName isEqualToString:@"MarkerGround0"])
        {
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"ground.png"]] size:CGSizeMake(75, 75)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
           // square.physicsBody.restitution = -1.0f;
            square.physicsBody.categoryBitMask = solidHitCategory;
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            //ground.physicsBody.restitution = -1.0f;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;

            [self addChild:square];
            [self.objectsArray addObject:square];
            [self checkOutOfBounds:square markerNumber:0];
            
        }else if([key isEqualToString:@"MarkerGround1"] && [brownButton.markerName isEqualToString:@"MarkerGround1"])
        {
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"ground.png"]] size:CGSizeMake(75, 75)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
           // square.physicsBody.restitution = -1.0f;
            square.physicsBody.categoryBitMask = solidHitCategory;
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            //ground.physicsBody.restitution = -1.0f;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;
            
            [self addChild:square];

            [self.objectsArray addObject:square];
            [self checkOutOfBounds:square markerNumber:1];

        }else if([key isEqualToString:@"MarkerGround2"] && [brownButton.markerName isEqualToString:@"MarkerGround2"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"ground.png"]] size:CGSizeMake(75, 75)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            //square.physicsBody.restitution = -1.0f;
            square.physicsBody.categoryBitMask = solidHitCategory;
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            //ground.physicsBody.restitution = -1.0f;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;

            [self addChild:square];

            [self checkOutOfBounds:square markerNumber:2];

        }else if([key isEqualToString:@"MarkerGround3"] && [brownButton.markerName isEqualToString:@"MarkerGround3"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"ground.png"]] size:CGSizeMake(75, 75)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
           // square.physicsBody.restitution = -1.0f;
            square.physicsBody.categoryBitMask = solidHitCategory;
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.size = CGSizeMake(20, square.size.height - 2);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, square.size.height - 2)];
            ground.position = CGPointMake(-square.size.height/2 + ground.size.width/2 , 0);
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            //ground.physicsBody.restitution = -1.0f;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;

            [self addChild:square];
            [self.objectsArray addObject:square];
            [self checkOutOfBounds:square markerNumber:3];

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
            
            [self addChild:square];
            [self.objectsArray addObject:square];
            [self checkOutOfBounds:square markerNumber:4];

        }else if([key isEqualToString:@"MarkerPlayerStart"] && [brownButton.markerName isEqualToString:@"MarkerPlayerStart"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            [self.objectsArray addObject:square];
            [self checkOutOfBounds:square markerNumber:5];
            
            SKSpriteNode *scoot = [[SKSpriteNode alloc] initWithImageNamed:@"scoot.png"];
            scoot.size = CGSizeMake(50, 50);
            scoot.position = square.position;
           // scoot.zRotation = M_PI/2;
            scoot.physicsBody.allowsRotation = NO;
            scoot.physicsBody.angularVelocity = 0.0f;
            scoot.name = @"scoot";
            //scoot.physicsBody.restitution = -1.0f;
            scoot.physicsBody.affectedByGravity = YES;
            scoot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(48, 48)];
           // scoot.anchorPoint = CGPointMake(0.5, 0.5);
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
            //feet.physicsBody.restitution = -1.0f;
            feet.physicsBody.dynamic = YES;
            feet.physicsBody.categoryBitMask = playerFeetCategory;
            feet.physicsBody.collisionBitMask = groundHitCategory;
            feet.physicsBody.contactTestBitMask =  groundHitCategory;
            feet.physicsBody.pinned = YES;
            scoot.physicsBody.contactTestBitMask = projectileCategory | solidHitCategory;
            scoot.physicsBody.collisionBitMask =  projectileCategory | solidHitCategory;
//            SKPhysicsJointFixed *joint = [SKPhysicsJointFixed jointWithBodyA:scoot.physicsBody
//                                                                       bodyB:feet.physicsBody
//                                                                      anchor:feet.position];
//            [self.physicsWorld addJoint:joint];
            [self addChild:scoot];
            NSLog(@"%@", NSStringFromCGRect(self.frame));
            //[self addChild:square];
        }else if([key isEqualToString:@"MarkerPlatform"] && [brownButton.markerName isEqualToString:@"MarkerPlatform"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"platformTexture.png"]] size:CGSizeMake(50, 50)];
            //square.zRotation = M_PI/2;
            square.name = @"platform";
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            CGPoint originalPosition = CGPointMake(square.position.x, square.position.y);
            square.anchorPoint = CGPointMake(.5, .5);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.restitution = 0.0f;
            square.physicsBody.categoryBitMask = solidHitCategory;
            [self addChild:square];
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.position = CGPointMake(-square.size.height/2, 0);
            ground.size = CGSizeMake(square.size.width, 2);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(2, square.size.height - 1)];
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.restitution = 0.0f;
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;
            [self.objectsArray addObject:square];
            [self checkOutOfBounds:square markerNumber:4];
            SKAction *moveLeft = [SKAction moveToX:originalPosition.x - 50 duration:3.0f];
            SKAction *moveRight = [SKAction moveToX:originalPosition.x + 50 duration:3.0f];
            SKAction *backAndForth = [SKAction sequence:@[moveLeft, moveRight]];
            SKAction *platformMove = [SKAction repeatActionForever:backAndForth];
            [square runAction:platformMove];
//        }else if([key isEqualToString:@"MarkerPlatform"] && [brownButton.markerName isEqualToString:@"MarkerPlatform"]){
//            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"platformTexture.png"]] size:CGSizeMake(50, 50)];
//            //square.zRotation = M_PI/2;
//            square.name = @"platform";
//            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
//            CGPoint originalPosition = CGPointMake(square.position.x, square.position.y);
//            square.anchorPoint = CGPointMake(.5, .5);
//            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
//            square.physicsBody.affectedByGravity = NO;
//            square.physicsBody.dynamic = NO;
//            square.physicsBody.categoryBitMask = solidHitCategory;
//            square.physicsBody.restitution = -1.0f;
//            //square.physicsBody.contactTestBitMask = groundHitCategory;
//            square.physicsBody.usesPreciseCollisionDetection = YES;
//            [self addChild:square];
//            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
//            [square addChild:ground];
//            ground.position = CGPointMake(-square.size.height/2, 0);
//            ground.size = CGSizeMake(square.size.width, 2);
//            ground.physicsBody.restitution = -1.0f;
//            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(2, square.size.height - 10)];
//            ground.physicsBody.affectedByGravity = NO;
//            ground.physicsBody.dynamic = NO;
//            ground.physicsBody.categoryBitMask = groundHitCategory;
//            ground.physicsBody.collisionBitMask = groundHitCategory;
//
//            [self.objectsArray addObject:square];
//            [self checkOutOfBounds:square markerNumber:4];
//            SKAction *moveLeft = [SKAction moveToX:originalPosition.x - 50 duration:3.0f];
//            SKAction *moveRight = [SKAction moveToX:originalPosition.x + 50 duration:3.0f];
//            SKAction *backAndForth = [SKAction sequence:@[moveLeft, moveRight]];
//            SKAction *platformMove = [SKAction repeatActionForever:backAndForth];
//            [square runAction:platformMove];
        }else if([key isEqualToString:@"MarkerPlatform2"] && [brownButton.markerName isEqualToString:@"MarkerPlatform2"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"platformTexture2.png"]] size:CGSizeMake(50, 50)];
            //square.zRotation = M_PI/2;
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
            //square.physicsBody.contactTestBitMask = groundHitCategory;
            square.physicsBody.usesPreciseCollisionDetection = YES;
            [self addChild:square];
            SKSpriteNode *ground = [[SKSpriteNode alloc] init];
            [square addChild:ground];
            ground.position = CGPointMake(-square.size.height/2, 0);
            ground.size = CGSizeMake(square.size.width, 2);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(2, square.size.height - 1)];
            ground.physicsBody.affectedByGravity = NO;
            ground.physicsBody.dynamic = NO;
            ground.physicsBody.restitution = 0.0f;
            ground.physicsBody.categoryBitMask = groundHitCategory;
            ground.physicsBody.collisionBitMask = groundHitCategory;

            
            [self.objectsArray addObject:square];
            [self checkOutOfBounds:square markerNumber:4];
            SKAction *moveLeft = [SKAction moveToY:originalPosition.y - 50 duration:3.0f];
            SKAction *moveRight = [SKAction moveToY:originalPosition.y + 50 duration:3.0f];
            SKAction *backAndForth = [SKAction sequence:@[moveLeft, moveRight]];
            SKAction *platformMove = [SKAction repeatActionForever:backAndForth];
            [square runAction:platformMove];
        }else if([key isEqualToString:@"MarkerEnemy1"] && [brownButton.markerName isEqualToString:@"MarkerEnemy1"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"enemy1Texture.png"]] size:CGSizeMake(50, 50)];
            //square.zRotation = M_PI/2;
            square.name = @"enemy1";
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.xScale = -1.0f;
            CGPoint originalPosition = CGPointMake(square.position.x, square.position.y);
            square.anchorPoint = CGPointMake(.5, .5);
            square.zRotation = M_PI/2;
           // square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            //square.physicsBody.affectedByGravity = NO;
            //square.physicsBody.dynamic = NO;
            //square.physicsBody.collisionBitMask = playerHitCategory;
            //square.physicsBody.categoryBitMask = winLevelCategory;
           // square.physicsBody.contactTestBitMask = playerHitCategory;
            [self addChild:square];
            [self.objectsArray addObject:square];
            [self checkOutOfBounds:square markerNumber:4];
            NSTimer *attack = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(enemyAttack) userInfo:nil repeats:YES];
            
        }
        
        
    }

self.view.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
    scoot.physicsBody.allowsRotation = NO;
    [scoot childNodeWithName:@"feet"].physicsBody.allowsRotation = NO;
}

-(void)checkOutOfBounds:(SKSpriteNode *)square markerNumber:(int)markerNum{
    CGFloat minX = CGRectGetMinX(self.scene.frame);
    CGFloat maxX = CGRectGetMaxX(self.scene.frame);
    CGFloat minY = CGRectGetMinY(self.scene.frame);
    CGFloat maxY = CGRectGetMaxY(self.scene.frame);
    
    NSLog(@"MinX:%f,MaxX:%f,MinY:%f,MaxY:%f",minX,maxX,minY,maxY);
    while((square.position.x < minX) || (square.position.y < minY) || (square.position.x > maxX) || (square.position.y > maxY)){
        for(SKSpriteNode *square in self.objectsArray){
            if(square.position.x < minX){
                NSLog(@"X: %f, Y: %f, I:%d", square.position.y, square.position.y, markerNum);
                square.position = CGPointMake(CGRectGetMinX(self.scene.frame) + square.size.width/2, square.position.y);
                NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
            }else if(square.position.y < minY){
                NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
                square.position = CGPointMake(square.position.x, CGRectGetMinY(self.scene.frame) + square.size.width/2);
                NSLog(@"X: %f, Y: %f", square.position.x, square.position.y);
            }else if(square.position.x > maxX){
                NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
                square.position = CGPointMake(CGRectGetMaxX(self.scene.frame)- square.size.width/2, square.position.y);
                NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
            }else if(square.position.y > maxY){
                NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
                square.position = CGPointMake(square.position.x, CGRectGetMaxY(self.scene.frame)- square.size.width/2);
                NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
            }
        }

    }
   // while(!(square.position.x < minX) && !(square.position.y < minY) && !(square.position.x > maxX) && !(square.position.y > maxY)){
//        if(square.position.x < minX){
//            
////            NSLog(@"X: %f, Y: %f, I:%d", square.position.y, square.position.y, markerNum);
////            square.position = CGPointMake(CGRectGetMinX(self.scene.frame) + square.size.width/2, square.position.y);
////            NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
//        }else if(square.position.y < minY){
////            NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
////            square.position = CGPointMake(square.position.x, CGRectGetMinY(self.scene.frame) + square.size.width/2);
////            NSLog(@"X: %f, Y: %f", square.position.x, square.position.y);
//        }else if(square.position.x > maxX){
////            NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
////            square.position = CGPointMake(CGRectGetMaxX(self.scene.frame)- square.size.width/2, square.position.y);
////            NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
//        }else if(square.position.y > maxY){
////            NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
////            square.position = CGPointMake(square.position.x, CGRectGetMaxY(self.scene.frame)- square.size.width/2);
////            NSLog(@"X: %f, Y: %f, I: %d", square.position.x, square.position.y, markerNum);
//        }
//    //}

    
}

-(void)enemyAttack{
    SKSpriteNode *enemy1 = (SKSpriteNode *)[self childNodeWithName:@"enemy1"];
    SKSpriteNode *enemyShot = [SKSpriteNode spriteNodeWithImageNamed:@"GEM.png"];
    enemyShot.size = CGSizeMake(25, 25);
    enemyShot.position = CGPointMake(enemy1.position.x, CGRectGetMaxY(enemy1.frame));
    enemyShot.anchorPoint = CGPointMake(.5, .5);
    enemyShot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemyShot.size];
    enemyShot.physicsBody.affectedByGravity = NO;
    enemyShot.physicsBody.dynamic = NO;
    enemyShot.zPosition = 1.0f;
    enemyShot.physicsBody.usesPreciseCollisionDetection = YES;
    enemyShot.physicsBody.categoryBitMask = projectileCategory;
    enemyShot.physicsBody.collisionBitMask = playerHitCategory | groundHitCategory;
    enemyShot.physicsBody.contactTestBitMask = playerHitCategory | groundHitCategory;
    SKAction *fireShot = [SKAction moveToY:2000 duration:5.0f];
    [self addChild:enemyShot];
    [enemyShot runAction:fireShot completion:^{
        enemyShot.hidden = YES;
        [enemyShot removeFromParent];
    }];
    NSLog(@"Enemy attacking");
}


-(void)checkForWin {
    if ([self childNodeWithName:@"scoot"].position.x > 1500 || [self childNodeWithName:@"scoot"].position.x < -1500 || [self childNodeWithName:@"scoot"].position.y > 1500 || [self childNodeWithName:@"scoot"].position.y < -1500) {
        [self gameOver:0];
    }
}

-(void)gameOver:(BOOL)won {
    self.gameOver = YES;
    //[self runAction:[SKAction playSoundFileNamed:@"hurt.wav" waitForCompletion:NO]];
    
    NSString *gameText;
    
    if (won) {
        gameText = @"You Won!";
    } else {
        gameText = @"You Lost!";
    }
    
    //1
    SKLabelNode *endGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    endGameLabel.text = gameText;
    endGameLabel.fontColor = [SKColor blackColor];
    endGameLabel.fontSize = 40;
    endGameLabel.xScale = -1.0f;
    endGameLabel.position = CGPointMake(self.size.width / 2.0, self.size.height / 1.7);
    endGameLabel.zRotation = M_PI/2;
    [self addChild:endGameLabel];
    
    //2
    self.replayButton= [UIButton buttonWithType:UIButtonTypeCustom];
    self.replayButton.tag = 321;
    UIImage *replayImage = [UIImage imageNamed:@"replay.png"];
    [self.replayButton setImage:replayImage forState:UIControlStateNormal];
    [self.replayButton addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
    self.replayButton.frame = CGRectMake(self.size.width / 2.0, self.size.height/2.0, 64, 64);
    [self.view addSubview:self.replayButton];
    self.replayButton.alpha = 1.0f;
    
    UIButton *newLevel = [UIButton buttonWithType:UIButtonTypeCustom];
    newLevel.tag = 322;
    UIImage *levelImage = [UIImage imageNamed:@"upArrow.png"];
    

    [newLevel setImage:levelImage forState:UIControlStateNormal];
    [newLevel addTarget:self.frameVc action:@selector(newLevel:) forControlEvents:UIControlEventTouchUpInside];
    newLevel.frame = CGRectMake(self.size.width / 2.0, self.size.height/2.0 - 80, 64, 64);
    [self.view addSubview:newLevel];
    
    NSLog(@"SKView final frame: %@", NSStringFromCGRect(self.frame));
    
}

-(void)newLevel:(id)sender{
    [self.gameSceneLoop stop];
}


- (void)replay:(id)sender
{
    [self.gameSceneLoop stop];
    self.replayButton.alpha = 0.0f;
    [[self.view viewWithTag:322] removeFromSuperview];
    GameScene * scene = [GameScene sceneWithSize:CGSizeMake(self.size.width, self.size.height)];
    scene.objectInfoDictionary = self.objectInfoDictionary;
    [self.view presentScene:scene];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if((firstBody.categoryBitMask == groundHitCategory && secondBody.categoryBitMask == playerFeetCategory ) || (firstBody.categoryBitMask == playerFeetCategory && secondBody.categoryBitMask == groundHitCategory))
    {
        if([self childNodeWithName:@"scoot"].physicsBody.velocity.dx < 100 && [self childNodeWithName:@"scoot"].physicsBody.velocity.dx > -100){
            _isTouchingGround = YES;
            SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
            [scoot.physicsBody setVelocity:CGVectorMake(0, scoot.physicsBody.velocity.dy)];
            NSLog(@"Begin");
        }
        //Player hit the ground
    }

    
    if(firstBody.categoryBitMask == solidHitCategory || secondBody.categoryBitMask == solidHitCategory)
    {
//        CGFloat impulseX = 0.0f;
//        CGFloat impulseY = 0.0f;
//        [firstBody applyImpulse:CGVectorMake(impulseX, impulseY)];
//        [secondBody applyImpulse:CGVectorMake(impulseX, impulseY)];

    }
    
    if((firstBody.categoryBitMask == winLevelCategory && secondBody.categoryBitMask == playerHitCategory) ||
       (firstBody.categoryBitMask == playerHitCategory && secondBody.categoryBitMask == winLevelCategory )){
        [self gameOver:1];
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if((firstBody.categoryBitMask == groundHitCategory && secondBody.categoryBitMask == playerFeetCategory )|| (firstBody.categoryBitMask == playerFeetCategory && secondBody.categoryBitMask == groundHitCategory))
    {
//        SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
//        if(scoot.physicsBody.velocity.dy
            _isTouchingGround = NO;
        NSLog(@"End");
        
//        CGFloat impulseX = 0.0f;
//        CGFloat impulseY = 0.0f;
//        [[self childNodeWithName:@"scoot"].physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:[self childNodeWithName:@"scoot"].position];
        //Player hit the ground
    }
}


- (void) jump:(SKSpriteNode*)obj
{
    NSLog(@"Touching Ground: %d, VelX:%f VelY:%f", _isTouchingGround, obj.physicsBody.velocity.dx, obj.physicsBody.velocity.dx);
    //&& obj.physicsBody.velocity.dx > -30 && obj.physicsBody.velocity.dx < 30
    if (_isTouchingGround){
        _isTouchingGround = NO;
//        CGFloat impulseX = 250.0f;
//        CGFloat impulseY = 0.0f;
//        [obj.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY)];
            obj.physicsBody.velocity = CGVectorMake(-400, obj.physicsBody.velocity.dy);
    }
}



-(void)update:(NSTimeInterval)delta{
    if(self.gameOver) return;
//    
//    SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
//    scoot.physicsBody.allowsRotation = NO;
//    [scoot childNodeWithName:@"feet"].physicsBody.allowsRotation = NO;
//    [self childNodeWithName:@"scoot"].physicsBody.angularVelocity = 0.0f;
    //    if([self isGroundPixel:self.backgroundImageView.image:[self childNodeWithName:@"scoot"].position.x :[self childNodeWithName:@"scoot"].position.y]){
    //        NSLog(@"%@", [self getRGBAsFromImage:self.backgroundImageView.image atX:[self childNodeWithName:@"scoot"].position.x andY:[self childNodeWithName:@"scoot"].position.y count:1]);
    //        NSLog(@"GROUND COLLISION");
    //    }
    //
    
    [self checkForWin];
    
    //NSLog(@"XVel:%f, YVel:%f", [self childNodeWithName:@"scoot"].physicsBody.velocity.dx, [self childNodeWithName:@"scoot"].physicsBody.velocity.dx);

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint loc = [touch locationInNode:self];
   // NSLog(@"Touch X: %f, Touch Y: %f", loc.x, loc.y);
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        
        if([n.name isEqualToString:@"rightArrow"]){
            if([[self childNodeWithName:@"scoot"] actionForKey:@"moveLeft"]){
                [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveLeft"];
            }
            SKAction *moveRight = [SKAction moveByX:0.0f y:10000.0f duration:50.0f];
            [[self childNodeWithName:@"scoot"] runAction:moveRight withKey:@"moveRight"];
            [self childNodeWithName:@"scoot"].yScale = 1.0f;

        }
        else if([n.name isEqualToString:@"leftArrow"]){
            if([[self childNodeWithName:@"scoot"] actionForKey:@"moveRight"]){
                [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveRight"];
            }
            SKAction *moveLeft = [SKAction moveByX:0.0f y:-10000.0f duration:50.0f];
            [[self childNodeWithName:@"scoot"] runAction:moveLeft withKey:@"moveLeft"];
            [self childNodeWithName:@"scoot"].yScale = -1.0f;
        } else if([n.name isEqualToString:@"upArrow"]){
            NSLog(@"Jump!");
            [self jump:(SKSpriteNode *)[self childNodeWithName:@"scoot"]];
        }
        
    }
    
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if([n.name isEqualToString:@"rightArrow"]){
            [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveRight"];
        }else if([n.name isEqualToString:@"leftArrow"]){
            [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveLeft"];
            
        }
        
    }
    
}



@end
