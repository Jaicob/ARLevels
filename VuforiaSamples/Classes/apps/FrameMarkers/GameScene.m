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

//bit masks
static const int playerHitCategory = 0x01;
static const int groundHitCategory = 0x10;
static const int winLevelCategory =  0x100;


-(void)didMoveToView:(SKView *)view{
    
    self.view.multipleTouchEnabled = YES;
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity=CGVectorMake(10, 0);
    self.backgroundColor = [UIColor whiteColor];
    
    SKTexture *backgroundTexture = [SKTexture textureWithImage:self.backgroundImage];
    self.background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    self.background.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    self.background.xScale = -1.0f;
    [self addChild:self.background];

    SKSpriteNode *rightArrow = [SKSpriteNode spriteNodeWithImageNamed:@"rightArrow.png"];
    rightArrow.size = CGSizeMake(50, 50);
    rightArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - rightArrow.size.width/2 - 10, CGRectGetMaxY(self.view.frame) - rightArrow.size.height/2 - 10);
    rightArrow.name = @"rightArrow";
    rightArrow.zRotation = M_PI/2;
    rightArrow.zPosition = 5.0f;
    
    [self addChild:rightArrow];
    
    SKSpriteNode *leftArrow = [SKSpriteNode spriteNodeWithImageNamed:@"leftArrow.png"];
    leftArrow.size = CGSizeMake(50, 50);
    leftArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - leftArrow.size.width/2 - 10, CGRectGetMaxY(self.view.frame) - leftArrow.size.height/2 - 70);
    leftArrow.zRotation = M_PI/2;
    leftArrow.name = @"leftArrow";
    leftArrow.zPosition = 5.0f;
    [self addChild:leftArrow];
    
    SKSpriteNode *upArrow = [SKSpriteNode spriteNodeWithImageNamed:@"upArrow.png"];
    upArrow.size = CGSizeMake(50, 50);
    upArrow .position = CGPointMake(CGRectGetMaxX(self.view.frame) - leftArrow.size.width/2 - 10, upArrow.size.height/2 + 20);
    upArrow.zRotation = M_PI/2;
    upArrow.name = @"upArrow";
    upArrow.zPosition = 5.0f;
    [self addChild:upArrow];
    
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
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.anchorPoint = CGPointMake(0.5, 0.5);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = groundHitCategory;
            [self addChild:square];
            
        }else if([key isEqualToString:@"MarkerGround1"] && [brownButton.markerName isEqualToString:@"MarkerGround1"])
        {
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.anchorPoint = CGPointMake(.5, .5);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = groundHitCategory;
            [self addChild:square];
            
        }else if([key isEqualToString:@"MarkerGround2"] && [brownButton.markerName isEqualToString:@"MarkerGround2"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.anchorPoint = CGPointMake(.5, .5);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = groundHitCategory;
            [self addChild:square];
        }else if([key isEqualToString:@"MarkerGround3"] && [brownButton.markerName isEqualToString:@"MarkerGround3"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.anchorPoint = CGPointMake(.5, .5);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = groundHitCategory;
            [self addChild:square];
        }
        else if([key isEqualToString:@"MarkerGold"] && [brownButton.markerName isEqualToString:@"MarkerGold"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor yellowColor] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            square.anchorPoint = CGPointMake(.5, .5);
            square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
            square.physicsBody.affectedByGravity = NO;
            square.physicsBody.dynamic = NO;
            square.physicsBody.categoryBitMask = winLevelCategory;
            square.physicsBody.contactTestBitMask = playerHitCategory;
            
            [self addChild:square];
        }else if([key isEqualToString:@"MarkerPlayerStart"] && [brownButton.markerName isEqualToString:@"MarkerPlayerStart"]){
            SKSpriteNode *square = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
            square.position = CGPointMake(brownButton.frame.origin.x, brownButton.frame.origin.y);
            SKSpriteNode *scoot = [[Player alloc] initWithImageNamed:@"scoot.png"];
            scoot.size = CGSizeMake(50, 50);
            scoot.position = square.position;
            scoot.zRotation = M_PI/2;
            scoot.name = @"scoot";
            scoot.physicsBody.affectedByGravity = YES;
            scoot.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:scoot.size.width/2];
            scoot.physicsBody.categoryBitMask = playerHitCategory;
            scoot.physicsBody.contactTestBitMask = groundHitCategory; //& winLevelCategory;
            scoot.physicsBody.collisionBitMask =  groundHitCategory;
            [self addChild:scoot];
            scoot.zPosition = 1.0f;
            NSLog(@"%@", NSStringFromCGRect(self.frame));
            
            //[self addChild:square];
        }
        
        
    }
    
    
    
    
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
    if((firstBody.categoryBitMask == winLevelCategory && secondBody.categoryBitMask == playerHitCategory) ||
       (firstBody.categoryBitMask == playerHitCategory && secondBody.categoryBitMask == winLevelCategory )){
        [self gameOver:1];
    }
}

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

-(UIImage*)snapshot
{
    // Captures SpriteKit content!
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
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
    // UIImage *screenGrab = [self snapshot];
    
    //  [self.uiView addSubview:screenGrab];
    CGPoint loc = [touch locationInNode:self];
    NSLog(@"loc x: %f, loc y: %f", loc.x, loc.y);
    self.pickedColor = [self colorOfPoint:loc];
    // [self getRGBAsFromImage:screenGrab atX:loc.x andY:loc.y count:1];
    
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        
        //        [self getRGBAsFromImage:self.backgroundImageView.image atX:n.frame.origin.x andY:n.frame.origin.y count:4];
        //        [self getGreenFromImage:self.backgroundImageView.image atX:n.frame.origin.x andY:n.frame.origin.y];
        if([n.name isEqualToString:@"rightArrow"]){
            if([[self childNodeWithName:@"scoot"] actionForKey:@"moveLeft"]){
                [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveLeft"];
            }
            SKAction *moveRight = [SKAction moveByX:0.0f y:10000.0f duration:50.0f];
            //SKAction *keepMovingRight = [SKAction repeatActionForever:moveRight];
            [[self childNodeWithName:@"scoot"] runAction:moveRight withKey:@"moveRight"];
        }
        else if([n.name isEqualToString:@"leftArrow"]){
            if([[self childNodeWithName:@"scoot"] actionForKey:@"moveRight"]){
                [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveRight"];
            }
            SKAction *moveLeft = [SKAction moveByX:0.0f y:-10000.0f duration:50.0f];
            //[[self childNodeWithName:@"scoot"] runAction:moveLeft];
            //SKAction *keepMovingLeft = [SKAction repeatActionForever:moveLeft];
            [[self childNodeWithName:@"scoot"] runAction:moveLeft withKey:@"moveLeft"];
        } else if([n.name isEqualToString:@"upArrow"]){
            [self jump:(SKSpriteNode *)[self childNodeWithName:@"scoot"]];
        }
        
    }
    
}

-(UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.view.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0
                                     green:pixel[1]/255.0 blue:pixel[2]/255.0
                                     alpha:pixel[3]/255.0];
    
    return color;
}

-(SKColor *)pixelFromTexture:(SKTexture *)texture position:(CGPoint)position{
    //    SKView *view =[[SKView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    //    SKScene *scene = [SKScene sceneWithSize:CGSizeMake(1, 1)];
    //    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];
    //    sprite.anchorPoint = CGPointZero;
    //    sprite.position = CGPointMake(-floor(position.x),-floor(position.y));
    //    scene.anchorPoint = CGPointZero;
    //    [scene addChild:sprite];
    //    [view presentScene:scene];
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixel[4] = { 0, 0, 0, 0 };
    CGBitmapInfo bitmapInfo = (CGBitmapInfo)kCGImageAlphaPremultipliedLast;
    CGContextRef context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
    UIGraphicsPushContext(context);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:true];
    UIGraphicsPopContext();
    return [SKColor colorWithRed:((CGFloat)(pixel[0])/ 255.0) green:((CGFloat)(pixel[1])/255.0) blue:((CGFloat)(pixel[2]) / 255.0) alpha:((CGFloat)(pixel[3]) / 255.0)];
    
}


//class func pixelFromTexture(texture: SKTexture, position: CGPoint) -> SKColor {
//    let view = SKView(frame: CGRectMake(0, 0, 1, 1))
//    let scene = SKScene(size: CGSize(width: 1, height: 1))
//    let sprite  = SKSpriteNode(texture: texture)
//    sprite.anchorPoint = CGPointZero
//    sprite.position = CGPoint(x: -floor(position.x), y: -floor(position.y))
//    scene.anchorPoint = CGPointZero
//    scene.addChild(sprite)
//    view.presentScene(scene)
//    var pixel: [Byte] = [0, 0, 0, 0]
//    let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
//    let context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
//    UIGraphicsPushContext(context);
//    view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
//    UIGraphicsPopContext()
//    return SKColor(red: CGFloat(pixel[0]) / 255.0, green: CGFloat(pixel[1]) / 255.0, blue: CGFloat(pixel[2]) / 255.0, alpha: CGFloat(pixel[3]) / 255.0)

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

-(CGFloat)getGreenFromImage:(UIImage*)image atX:(NSInteger)xx andY:(NSInteger)yy {
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), CGPointMake(xx,yy))) {
        return 0;
    }
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    NSInteger pointX = xx;
    NSInteger pointY = yy;
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = image.size.width;
    NSUInteger height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat green = (CGFloat)pixelData[2];
    return green;
}

//
-(NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    for (int i = 0 ; i < count ; ++i)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += bytesPerPixel;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}
//
//- (BOOL)isGroundPixel:(UIImage *) image: (int) x :(int) y {
//
//    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
//    const UInt8* data = CFDataGetBytePtr(pixelData);
//
//    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
//
//    //UInt8 red = data[pixelInfo];         // If you need this info, enable it
//    UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
//    //UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
//    UInt8 alpha = data[pixelInfo + 3];     // I need only this info for my maze game
//    CFRelease(pixelData);
//
//    //UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
//
//    if (alpha && green) return YES;
//    else return NO;
//
//}
//
///*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
//}
//
//- (BOOL)shouldAutorotate {
//
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations {
//
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//
//    return UIInterfaceOrientationLandscapeLeft;
//}*/
//



- (BOOL)isGroundPixel:(UIImage *)image :(int)x :(int)y {
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
    
    //UInt8 red = data[pixelInfo];         // If you need this info, enable it
    UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
    //UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
    UInt8 alpha = data[pixelInfo + 3];     // I need only this info for my maze game
    CFRelease(pixelData);
    
    //UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
    
    if (alpha && green) return YES;
    else return NO;
    
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
