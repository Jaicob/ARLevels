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


@interface ViewController : UIViewController <GKMatchDelegate, GKMatchmakerViewControllerDelegate, GKLocalPlayerListener>

@property (strong, nonatomic) UIButton *gnuLevelButton;
@property (strong, nonatomic) UIButton *savedLevelsButton;
@property (strong, nonatomic) UIButton *topLevelsButton;
@property (strong, nonatomic) UIButton *multiplayerButton;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * aboutPageName;
@property (nonatomic, copy) NSString * viewControllerClassName;

@property (nonatomic) BOOL newLevelTransition;

-(void)newLevel;
@end

