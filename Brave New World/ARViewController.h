//
//  ARViewController.h
//  Brave New World
//
//  Created by Justin Lennox on 3/24/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface ARViewController : UIViewController

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * aboutPageName;
@property (nonatomic, copy) NSString * viewControllerClassName;
@property(nonatomic,retain) UIViewController *rootViewController;
@property (nonatomic) BOOL newLevelTransition;

- (id)initWithRootViewController:(UIViewController*)controller;

- (void) showRootController:(BOOL)animated;

@end
