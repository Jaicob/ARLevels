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
@class GameScene;

@interface GameSceneViewController : UIViewController <SKSceneDelegate, UITextFieldDelegate>

@property (weak, nonatomic) SKView *skView;
@property (strong, nonatomic) GameScene *scene;
@property (weak, nonatomic) UIView *frameView;
@property (weak, nonatomic) UIViewController *frameViewController;
@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) NSMutableDictionary *objectInfoDictionary;

-(void)presentARViewController;
-(void)goBack;

@end
