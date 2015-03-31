//
//  ViewController.h
//  Brave New World
//
//  Created by Justin Lennox on 3/24/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedLevelsViewController.h"
#import <GameKit/GameKit.h>
#import <GameController/GameController.h>
#import <GameKit/GKLocalPlayer.h>
#import "GameKitHelper.h"
#import "MultiplayerNetworking.h"
#import "GameSceneViewController.h"

@interface ViewController : UIViewController <GKMatchDelegate, GKMatchmakerViewControllerDelegate, GKLocalPlayerListener, GameKitHelperDelegate, MultiplayerNetworkingProtocol>

@property (strong, nonatomic) UIButton *gnuLevelButton;
@property (strong, nonatomic) UIButton *savedLevelsButton;
@property (strong, nonatomic) UIButton *topLevelsButton;
@property (strong, nonatomic) UIButton *multiplayerButton;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * aboutPageName;
@property (nonatomic, copy) NSString * viewControllerClassName;

@property (nonatomic, strong) MultiplayerNetworking *networkingEngine;
@property (nonatomic, copy) void (^gameOverBlock)(BOOL didWin);
@property (nonatomic, copy) void (^gameEndedBlock)();

@property (strong, nonatomic) NSMutableDictionary *multiplayerObjectDictionary;

@property (nonatomic) BOOL newLevelTransition;

-(void)newLevel;
-(void)startGame;
@end

