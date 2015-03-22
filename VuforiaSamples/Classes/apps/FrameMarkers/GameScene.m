//
//  GameScene.m
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "GameScene.h"
#import "SKTUtils.h"
#import "customButton.h"


@implementation GameScene


static const int playerHitCategory = 1;
static const int groundHitCategory = 2;

-(void)didMoveToView:(SKView *)view{
    
    self.view.multipleTouchEnabled = YES;
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity=CGVectorMake(10, 0);

    
    self.backgroundColor = [UIColor whiteColor];
    
  //  NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
   // [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    //rotate image
//    UIImageView *myImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
//    myImageView.center = CGPointMake(100.0, 100.0);
//    myImageView.transform = CGAffineTransformMakeRotation(M_PI); //rotation in radians
//    myImageView.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    
  //  [self getRGBAsFromImage:myImageView.image atX:0 andY:0 count:1];
//    for(int x = 0; x < 300; x++){
//        for (int y = 0; y < 300; y++){
//            if([self getGreenFromImage:myImageView.image atX:x andY:y] > 50){
//                SKSpriteNode *node = [[SKSpriteNode alloc] init];
//                node.size = CGSizeMake(1, 1);
//                node.color = [UIColor brownColor];
//                
//            }
//        }
//    }
 //   [self getGreenFromImage:myImageView.image atX:100 andY:100];
    
//    self.backgroundImage = myImageView.image;
    
    
    
    //SKTexture *backgroundTexture = [SKTexture textureWithImage:self.backgroundImage];
    //self.background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    //self.background.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    //[self addChild:self.background];
    
//    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:self.backgroundImage.CGImage
//                                                                                              scale:self.backgroundImage.scale
//                                                                                        orientation:UIImageOrientationLeftMirrored]];
//    self.backgroundImageView.frame = CGRectMake(0,  0, self.size.width, self.size.height);
//    [self.view addSubview:self.backgroundImageView];
//    [self.view sendSubviewToBack:self.backgroundImageView];

    
//    self.collisionReferenceImage = [self snapshot];
//    UIImageView *collisionReferenceView = [[UIImageView alloc]initWithImage:self.collisionReferenceImage];
//    collisionReferenceView.frame = CGRectMake(200, 200, 75, 75);
//    [self.view addSubview:collisionReferenceView];
//    
    SKSpriteNode *rightArrow = [SKSpriteNode spriteNodeWithImageNamed:@"rightArrow.png"];
    rightArrow.size = CGSizeMake(50, 50);
        rightArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - rightArrow.size.width/2 - 10, rightArrow.size.height/2 + 80);
    rightArrow.name = @"rightArrow";
    rightArrow.zRotation = M_PI/2;
    rightArrow.zPosition = 5.0f;

    [self addChild:rightArrow];
    
    SKSpriteNode *leftArrow = [SKSpriteNode spriteNodeWithImageNamed:@"leftArrow.png"];
    leftArrow.size = CGSizeMake(50, 50);
    leftArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - leftArrow.size.width/2 - 10, rightArrow.size.height/2 + 20);
    leftArrow.zRotation = M_PI/2;
    leftArrow.name = @"leftArrow";
    leftArrow.zPosition = 5.0f;
    [self addChild:leftArrow];
    
    SKSpriteNode *upArrow = [SKSpriteNode spriteNodeWithImageNamed:@"upArrow.png"];
    upArrow.size = CGSizeMake(50, 50);
    upArrow .position = CGPointMake(CGRectGetMaxX(self.view.frame) - leftArrow.size.width/2 - 10, CGRectGetMaxY(self.view.frame) - rightArrow.size.height/2 - 10);
    upArrow.zRotation = M_PI/2;
    upArrow.name = @"upArrow";
    upArrow.zPosition = 5.0f;
    [self addChild:upArrow];
    
    SKSpriteNode *scoot = [[Player alloc] initWithImageNamed:@"scoot.png"];
    scoot.size = CGSizeMake(50, 50);
    scoot.position = CGPointMake(CGRectGetMidX(self.view.frame), scoot.size.height/2 + 10);
    scoot.zRotation = M_PI/2;
    scoot.name = @"scoot";
    scoot.physicsBody.affectedByGravity = YES;
    scoot.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:scoot.size.width/2];
    scoot.physicsBody.categoryBitMask = playerHitCategory;
    scoot.physicsBody.contactTestBitMask = groundHitCategory;
    scoot.physicsBody.collisionBitMask =  groundHitCategory;
    [self addChild:scoot];
    scoot.zPosition = 1.0f;
    scoot.xScale = -1.0f;
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    
    SKSpriteNode *tempGround = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(500, 100)];
    tempGround.position = CGPointMake(340, 0);
    tempGround.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tempGround.size];
    tempGround.physicsBody.affectedByGravity = NO;
    tempGround.physicsBody.dynamic = NO;
    tempGround.physicsBody.categoryBitMask = groundHitCategory;
    tempGround.zRotation = M_PI/2;

    [self addChild:tempGround];
    
    self.uiView = [[UIView alloc] init];
    [self.view addSubview:self.uiView];
    
    self.brownButtonArray = [[NSMutableArray alloc] init];
    //tempGround.physicsBody.contactTestBitMask = groundHitCategory;
    //tempGround.physicsBody.collisionBitMask =  groundHitCategory;

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
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ground.png"] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x/2, brownButton.frame.origin.y/2);
            square.anchorPoint = CGPointMake(1, 0);
            [self addChild:square];
            
        }else if([key isEqualToString:@"MarkerGround1"] && [brownButton.markerName isEqualToString:@"MarkerGround1"])
        {
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ground.png"] size:CGSizeMake(50, 50)];

            square.position = CGPointMake(brownButton.frame.origin.x/2, brownButton.frame.origin.y/2);
            square.anchorPoint = CGPointMake(1, 0);
            [self addChild:square];
            
        }else if([key isEqualToString:@"MarkerGround2"] && [brownButton.markerName isEqualToString:@"MarkerGround2"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ground.png"] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x/2, brownButton.frame.origin.y/2);
            square.anchorPoint = CGPointMake(1, 0);
            [self addChild:square];
        }else if([key isEqualToString:@"MarkerGround3"] && [brownButton.markerName isEqualToString:@"MarkerGround3"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"ground.png"] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x/2, brownButton.frame.origin.y/2);
            square.anchorPoint = CGPointMake(1, 0);
            [self addChild:square];
        }
        else if([key isEqualToString:@"MarkerGold"] && [brownButton.markerName isEqualToString:@"MarkerGold"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"gold.png"] size:CGSizeMake(50, 50)];
            square.zRotation = M_PI/2;
            square.position = CGPointMake(brownButton.frame.origin.x/2, brownButton.frame.origin.y/2);
            [self addChild:square];
        }else if([key isEqualToString:@"MarkerPlayerStart"] && [brownButton.markerName isEqualToString:@"MarkerPlayerStart"]){
            SKSpriteNode *square =[SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"frame.png"] size:CGSizeMake(50, 50)];

            square.position = CGPointMake(brownButton.frame.origin.x/2, brownButton.frame.origin.y/2);
            [self addChild:square];
        }
        
        
    }
    
    
    self.view.transform = CGAffineTransformMakeScale(1.0, -1.0);

    

    

    
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
    endGameLabel.fontSize = 40;
    endGameLabel.position = CGPointMake(self.size.width / 2.0, self.size.height / 1.7);
    endGameLabel.zRotation = M_PI/2;
    [self addChild:endGameLabel];
    
    //2
    UIButton *replay = [UIButton buttonWithType:UIButtonTypeCustom];
    replay.tag = 321;
    UIImage *replayImage = [UIImage imageNamed:@"replay.png"];
    [replay setImage:replayImage forState:UIControlStateNormal];
    [replay addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
    replay.frame = CGRectMake(self.size.width / 2.0, self.size.height/2.0, 64, 64);
    [self.view addSubview:replay];
    
    NSLog(@"SKView final frame: %@", NSStringFromCGRect(self.frame));

}


- (void)replay:(id)sender
{
    [[self.view viewWithTag:321] removeFromSuperview];
    GameScene * scene = [GameScene sceneWithSize:CGSizeMake(self.size.height, self.size.width)];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    scene.backgroundImage = self.backgroundImage;
    [self.view presentScene:scene];
}




-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if(firstBody.categoryBitMask == groundHitCategory || secondBody.categoryBitMask == groundHitCategory)
    {
        _isTouchingGround = YES;
        CGFloat impulseX = 0.0f;
        CGFloat impulseY = 0.0f;
        [[self childNodeWithName:@"scoot"].physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:[self childNodeWithName:@"scoot"].position];

        //Player hit the ground
        
    }
}

//-(void)didEndContact:(SKPhysicsContact *)contact{
//    
//    
//    SKPhysicsBody *firstBody, *secondBody;
//    
//    firstBody = contact.bodyA;
//    secondBody = contact.bodyB;
//    
//    if(firstBody.categoryBitMask == groundHitCategory || secondBody.categoryBitMask == groundHitCategory)
//    {
//        _isTouchingGround = NO;
//
//    }
//
//    
//}

- (void) jump:(SKSpriteNode*)obj
{
    if (_isTouchingGround)
    {
        _isTouchingGround = NO;
        CGFloat impulseX = 200.0f;
        CGFloat impulseY = 0.0f;
        [obj.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:obj.position];
    }
}



-(void)update:(NSTimeInterval)delta{
    if(self.gameOver) return;
    
   

//    if([self isGroundPixel:self.backgroundImageView.image:[self childNodeWithName:@"scoot"].position.x :[self childNodeWithName:@"scoot"].position.y]){
//        NSLog(@"%@", [self getRGBAsFromImage:self.backgroundImageView.image atX:[self childNodeWithName:@"scoot"].position.x andY:[self childNodeWithName:@"scoot"].position.y count:1]);
//        NSLog(@"GROUND COLLISION");
//    }
//    
    
   [self checkForWin];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];

    CGPoint loc = [touch locationInNode:self];
    
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        
        if([n.name isEqualToString:@"rightArrow"]){
            if([[self childNodeWithName:@"scoot"] actionForKey:@"moveLeft"]){
                 [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveLeft"];
            }
            SKAction *moveRight = [SKAction moveByX:0.0f y:10000.0f duration:50.0f];
            [[self childNodeWithName:@"scoot"] runAction:moveRight withKey:@"moveRight"];
            [self childNodeWithName:@"scoot"].xScale = 1.0f;

        }
        else if([n.name isEqualToString:@"leftArrow"]){
            if([[self childNodeWithName:@"scoot"] actionForKey:@"moveRight"]){
                [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveRight"];
            }
            SKAction *moveLeft = [SKAction moveByX:0.0f y:-10000.0f duration:50.0f];
            [[self childNodeWithName:@"scoot"] runAction:moveLeft withKey:@"moveLeft"];
            [self childNodeWithName:@"scoot"].xScale = -1.0f;
        } else if([n.name isEqualToString:@"upArrow"]){
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



/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationLandscapeLeft;
}*/


@end
