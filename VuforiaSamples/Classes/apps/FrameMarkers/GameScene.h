//
//  GameScene.h
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (strong, nonatomic) SKSpriteNode *background;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIImage *collisionReferenceImage;
@property (strong, nonatomic) SKSpriteNode *playerSpriteNode;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) BOOL isTouchingGround;
@property (strong, nonatomic) NSMutableDictionary *objectInfoDictionary;
@property (strong, nonatomic) NSMutableArray *brownButtonArray;
@property (strong, nonatomic) NSMutableArray *objectsArray;

@property (nonatomic, assign) BOOL gameOver;
@property (nonatomic, assign) NSTimeInterval previousUpdateTime;
@property (strong, nonatomic) UIColor *pickedColor;
@property (strong, nonatomic) UIView *uiView;
@property (strong, nonatomic) AVAudioPlayer *gameSceneLoop;

@end
