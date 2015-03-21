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
    
    SKSpriteNode *scoot = [SKSpriteNode spriteNodeWithImageNamed:@"scoot.png"];
    scoot.size = CGSizeMake(50, 50);
    scoot.position = CGPointMake(self.size.height/2 + scoot.size.width/2, scoot.size.height/2);
    scoot.zRotation = M_PI/2;
    [self addChild:scoot];
    NSLog(@"%@", NSStringFromCGRect(self.frame));


    
    
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
