//
//  ViewController.h
//  Brave New World
//
//  Created by Justin Lennox on 3/24/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

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

