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
#import "GameSceneViewController.h"
#import "GameKitHelper.h"
#import "MultiplayerNetworking.h"

@class GameSceneViewController;

@interface GameScene : SKScene <SKPhysicsContactDelegate, UITextFieldDelegate, UIAlertViewDelegate, GameKitHelperDelegate, MultiplayerNetworkingProtocol>

@property (strong, nonatomic) SKSpriteNode *background;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIImage *collisionReferenceImage;
@property (strong, nonatomic) SKSpriteNode *playerSpriteNode;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) BOOL isTouchingGround;
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine;
@property (nonatomic, retain) GameSceneViewController *delegate;
@property (strong, nonatomic) NSMutableArray *brownButtonArray;
@property (weak, nonatomic) UIViewController *frameVc;
@property (strong, nonatomic) NSMutableArray *objectsArray;
@property (nonatomic) int playerNumber;
@property (nonatomic, assign) BOOL gameOver;
@property (nonatomic, assign) NSTimeInterval previousUpdateTime;
@property (strong, nonatomic) UIColor *pickedColor;
@property (strong, nonatomic) UIView *uiView;
@property (strong, nonatomic) AVAudioPlayer *gameSceneLoop;

@property (nonatomic) BOOL movingLeft;
@property (nonatomic) BOOL movingRight;

@property (nonatomic) BOOL isMultiplayer;

//Dictionaries
@property (strong, nonatomic) NSMutableDictionary *objectInfoDictionary;
@property (strong, nonatomic) NSMutableDictionary *spriteDictionary;

//UI/EndGameButtons
@property (strong, nonatomic) UIButton *replayButton;
@property (strong, nonatomic) UIButton *gnuLevelButton;
@property (strong, nonatomic) UIButton *saveLevelButton;
@property (strong, nonatomic) UITextField *levelTitleTextField;

//Enemy Methods
-(void)enemy1Attack;
@property (strong, nonatomic) NSTimer *enemy1Timer;

@end
