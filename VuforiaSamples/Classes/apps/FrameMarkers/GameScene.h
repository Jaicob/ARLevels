//
//  GameScene.h
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property (strong, nonatomic) SKSpriteNode *background;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIImage *collisionReferenceImage;
@property (strong, nonatomic) SKSpriteNode *playerSpriteNode;
@property (strong, nonatomic) UIImageView *backgroundImageView;

@end
