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
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    self.backgroundColor = [UIColor whiteColor];
    
    //rotate image
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    myImageView.center = CGPointMake(100.0, 100.0);
    myImageView.transform = CGAffineTransformMakeRotation(M_PI); //rotation in radians
    
    self.backgroundImage = myImageView.image;
    
    SKTexture *backgroundTexture = [SKTexture textureWithImage:self.backgroundImage];
    self.background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    self.background.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    self.background.yScale = -1.0f;
    [self addChild:self.background];
    
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
    rightArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - rightArrow.size.width/2 - 10, CGRectGetMaxY(self.view.frame) - rightArrow.size.height/2 - 10);
    rightArrow.size = CGSizeMake(50, 50);
    rightArrow.name = @"rightArrow";
    rightArrow.zRotation = M_PI/2;
    rightArrow.zPosition = 1.0f;

    [self addChild:rightArrow];
    
    SKSpriteNode *leftArrow = [SKSpriteNode spriteNodeWithImageNamed:@"leftArrow.png"];
    leftArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - leftArrow.size.width/2 - 10, CGRectGetMaxY(self.view.frame) - leftArrow.size.height/2 - 70);
    leftArrow.size = CGSizeMake(50, 50);
    leftArrow.zRotation = M_PI/2;
    leftArrow.name = @"leftArrow";
    leftArrow.zPosition = 1.0f;
    [self addChild:leftArrow];
    
    SKSpriteNode *scoot = [SKSpriteNode spriteNodeWithImageNamed:@"scoot.png"];
    scoot.size = CGSizeMake(50, 50);
    scoot.position = CGPointMake(CGRectGetMidX(self.view.frame), scoot.size.height/2 + 10);
    scoot.zRotation = M_PI/2;
    scoot.name = @"scoot";
    [self addChild:scoot];
    scoot.zPosition = 1.0f;
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    
    
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

-(void)update:(CFTimeInterval)currentTime{
    if([self isGroundPixel:self.backgroundImageView.image:[self childNodeWithName:@"scoot"].position.x :[self childNodeWithName:@"scoot"].position.y]){
        NSLog(@"%@", [self getRGBAsFromImage:self.backgroundImageView.image atX:[self childNodeWithName:@"scoot"].position.x andY:[self childNodeWithName:@"scoot"].position.y count:1]);
        NSLog(@"GROUND COLLISION");
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if([n.name isEqualToString:@"rightArrow"]){
            SKAction *moveRight = [SKAction moveByX:0.0f y:30.0f duration:0.1f];
            //SKAction *keepMovingRight = [SKAction repeatActionForever:moveRight];
            [[self childNodeWithName:@"scoot"] runAction:moveRight withKey:@"moveRight"];
        }
        else if([n.name isEqualToString:@"leftArrow"]){
            SKAction *moveLeft = [SKAction moveByX:0.0f y:-30.0f duration:0.1f];
            //[[self childNodeWithName:@"scoot"] runAction:moveLeft];
            //SKAction *keepMovingLeft = [SKAction repeatActionForever:moveLeft];
            [[self childNodeWithName:@"scoot"] runAction:moveLeft withKey:@"moveLeft"];
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

- (BOOL)isGroundPixel:(UIImage *) image: (int) x :(int) y {
    
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
