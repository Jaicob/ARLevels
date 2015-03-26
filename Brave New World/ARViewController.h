//
//  ARViewController.h
//  Brave New World
//
//  Created by Justin Lennox on 3/24/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARViewController : UIViewController

- (id)initWithRootViewController:(UIViewController*)controller;

- (void) showRootController:(BOOL)animated;

@end
