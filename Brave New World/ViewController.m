//
//  ViewController.m
//  Brave New World
//
//  Created by Justin Lennox on 3/24/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import "ViewController.h"
#import "ARViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"HomeView";
        //[self addApplication:@"Frame Markers" viewControllerClassName:@"FrameMarkersViewController" aboutPageName:@"FM_about"];

    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View Controller Loaded Baby");
    int numOfButtons = 4;
    int buttonHeight = 50;
    int buttonWidth = 200;
    int yStep = 100; //TO FIX: self.view.frame.size.height/(numOfButtons * buttonHeight);

    // Do any additional setup after loading the view, typically from a nib.
    self.gnuLevelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - buttonWidth/2, yStep, buttonWidth, buttonHeight)];
    self.gnuLevelButton.titleLabel.minimumScaleFactor = 5.0f;
    [self.gnuLevelButton setTitle:@"New Level" forState:UIControlStateNormal];
    self.gnuLevelButton.backgroundColor = [UIColor blueColor];
    self.gnuLevelButton.titleLabel.textColor = [UIColor whiteColor];
    [self.gnuLevelButton addTarget:self action:@selector(gnuLevelPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.gnuLevelButton];
    
    self.savedLevelsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - buttonWidth/2, 2*yStep, buttonWidth, buttonHeight)];
    [self.savedLevelsButton setTitle:@"Saved Levels" forState:UIControlStateNormal];
    self.savedLevelsButton.backgroundColor = [UIColor blueColor];
    self.savedLevelsButton.titleLabel.textColor = [UIColor whiteColor];
    [self.savedLevelsButton addTarget:self action:@selector(savedLevelsPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.savedLevelsButton];
    
    self.topLevelsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - buttonWidth/2, 3*yStep, buttonWidth, buttonHeight)];
    [self.topLevelsButton setTitle:@"Top Levels" forState:UIControlStateNormal];
    self.topLevelsButton.backgroundColor = [UIColor blueColor];
    self.topLevelsButton.titleLabel.textColor = [UIColor whiteColor];
    [self.topLevelsButton addTarget:self action:@selector(topLevelsPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.topLevelsButton];
    
    self.multiplayerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - buttonWidth/2, 4*yStep, buttonWidth, buttonHeight)];
    [self.multiplayerButton setTitle:@"Multiplayer" forState:UIControlStateNormal];
    self.multiplayerButton.backgroundColor = [UIColor blueColor];
    self.multiplayerButton.titleLabel.textColor = [UIColor whiteColor];
    [self.multiplayerButton addTarget:self action:@selector(multiplayerPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.multiplayerButton];
    
    NSLog(@"View controller did appear Baby");
    ViewController * app = [[[ViewController alloc]init] autorelease];
    app.title = @"Frame Markers";
    app.viewControllerClassName = @"FrameMarkersViewController";
    app.aboutPageName = @"FM_about";
    
    Class vcClass = NSClassFromString(@"FrameMarkersViewController");
    id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
    
    ARViewController *arViewController = [[ARViewController alloc] initWithRootViewController:vc];
    
    if(self.newLevelTransition == YES){
        arViewController.newLevelTransition = YES;
    }
    [self.navigationController pushViewController:arViewController animated:NO];
    [arViewController release];
    [vc release]; // don't leak memory

    
}

-(void)gnuLevelPressed{
    
    
    ViewController * app = [[[ViewController alloc]init] autorelease];
    app.title = @"Frame Markers";
    app.viewControllerClassName = @"FrameMarkersViewController";
    app.aboutPageName = @"FM_about";
    
    Class vcClass = NSClassFromString(@"FrameMarkersViewController");
    id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
    
    ARViewController *arViewController = [[ARViewController alloc] initWithRootViewController:vc];
    
    [self.navigationController pushViewController:arViewController animated:NO];
    [arViewController release];
    [vc release]; // don't leak memory

    
}

-(void)newLevel{
    
    ViewController * app = [[[ViewController alloc]init] autorelease];
    app.title = @"Frame Markers";
    app.viewControllerClassName = @"FrameMarkersViewController";
    app.aboutPageName = @"FM_about";
    
    Class vcClass = NSClassFromString(@"FrameMarkersViewController");
    id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
    
    ARViewController *arViewController = [[ARViewController alloc] initWithRootViewController:vc];
    [self.navigationController pushViewController:arViewController animated:NO];
    [arViewController release];
    [vc release]; // don't leak memory

    
}

-(void)savedLevelsPressed{
    
}

-(void)topLevelsPressed{
    
}

-(void)multiplayerPressed{
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

//- (void) addApplication:(NSString *)title viewControllerClassName:(NSString *) viewControllerClassName aboutPageName:(NSString *)aboutPageName{
//    ViewController * app = [[[ViewController alloc]init] autorelease];
//    app.title = title;
//    app.viewControllerClassName = viewControllerClassName;
//    app.aboutPageName = aboutPageName;
//    [self.sampleApplications addObject:app];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
