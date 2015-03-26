//
//  GameSceneViewController.m
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "GameSceneViewController.h"
#import "GameScene.h"

@interface GameSceneViewController ()

@end

@implementation GameSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
   /* self.skView = [[SKView alloc] init];
    _skView.showsFPS = YES;
    _skView.showsNodeCount = YES;
    
    _skView.allowsTransparency = NO;
    _skView.backgroundColor = [UIColor redColor];
    _skView.ignoresSiblingOrder = true;
    // Create and configure the scene.
    SKScene * scene = [GameScene sceneWithSize:CGSizeMake(500, 500)];
    scene.backgroundColor = [UIColor redColor];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self.skView presentScene:scene];*/
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
