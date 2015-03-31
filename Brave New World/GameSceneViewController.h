//
//  GameSceneViewController.h
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "AppDelegate.h"
#import "ARViewController.h"
#import "ViewController.h"
#import "GameScene.h"
#import "GameKitHelper.h"
#import "MultiplayerNetworking.h"
@class GameScene;

@interface GameSceneViewController : UIViewController <SKSceneDelegate, UITextFieldDelegate, GameKitHelperDelegate, MultiplayerNetworkingProtocol>

@property (weak, nonatomic) SKView *skView;
@property (strong, nonatomic) GameScene *scene;
@property (nonatomic) int playerNumber;
@property (weak, nonatomic) UIView *frameView;
@property (weak, nonatomic) UIViewController *frameViewController;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine;

@property (strong, nonatomic) NSMutableDictionary *objectInfoDictionary;
@property (strong, nonatomic) NSMutableDictionary *playerDictionary;
@property (strong, nonatomic) NSArray *orderPlayerArray;
@property (nonatomic) BOOL isMultiplayer;
-(void)presentARViewController;
-(void)goBack;

@end
