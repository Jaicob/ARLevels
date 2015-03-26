//
//  GameSceneViewController.h
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "ARViewController.h"
#import "ViewController.h"

@interface GameSceneViewController : UIViewController

@property (strong, nonatomic) SKView *skView;
@property (strong, nonatomic) GameScene *scene;
@property (strong, nonatomic) UIView *frameView;
@property (strong, nonatomic) UIViewController *frameViewController;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableDictionary *objectInfoDictionary;

-(void)presentARViewController;

@end
