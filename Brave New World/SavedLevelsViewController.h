//
//  SavedLevelsViewController.h
//  Brave New World
//
//  Created by Justin Lennox on 3/30/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScene.h"
#import "GameSceneViewController.h"

@interface SavedLevelsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *savedLevelsArray;
@property (nonatomic) BOOL matchmaking;
@property (strong, nonatomic) UIButton *doneButton;

@end
