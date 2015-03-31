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

@implementation ViewController{
    NSMutableArray *_players;
    NSUInteger _currentPlayerIndex;
}

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
    NSLog(@"ViewController viewDidLoad");
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
    
}

-(void)gnuLevelPressed{
    
    
    ViewController * app = [[ViewController alloc]init];
    app.title = @"Frame Markers";
    app.viewControllerClassName = @"FrameMarkersViewController";
    app.aboutPageName = @"FM_about";
    
    Class vcClass = NSClassFromString(@"FrameMarkersViewController");
    id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
    
    ARViewController *arViewController = [[ARViewController alloc] initWithRootViewController:vc];
    arViewController.newLevelTransition = NO;
    [self.navigationController pushViewController:arViewController animated:NO];
//    [arViewController release];
//    [vc release]; // don't leak memory

    
}

-(void)newLevel{
    
    ViewController * app = [[ViewController alloc]init];
    app.title = @"Frame Markers";
    app.viewControllerClassName = @"FrameMarkersViewController";
    app.aboutPageName = @"FM_about";
    
    Class vcClass = NSClassFromString(@"FrameMarkersViewController");
    id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
    
    ARViewController *arViewController = [[ARViewController alloc] initWithRootViewController:vc];
    [self.navigationController pushViewController:arViewController animated:NO];
//    [arViewController release];
//    [vc release]; // don't leak memory

    
}

-(void)savedLevelsPressed{
    SavedLevelsViewController *savedLevelsController = [[SavedLevelsViewController alloc] init];
    [self.navigationController presentViewController:savedLevelsController animated:NO completion:nil];
    
}

-(void)topLevelsPressed{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dictUserDefaults = [userDefaults dictionaryRepresentation];
    for (id akey in dictUserDefaults) {
        [userDefaults removeObjectForKey:akey];
    }
    [userDefaults synchronize];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"ViewController viewDidAppear");
    
//    if(self.newLevelTransition == YES){
//        NSLog(@"ViewController viewWillAppear New Transition");
//        
//        
//        ViewController * app = [[ViewController alloc]init];
//        app.title = @"Frame Markers";
//        app.viewControllerClassName = @"FrameMarkersViewController";
//        app.aboutPageName = @"FM_about";
//        
//        Class vcClass = NSClassFromString(@"FrameMarkersViewController");
//        id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
//        
//        ARViewController *arViewController = [[ARViewController alloc] initWithRootViewController:vc];
//        if(self.newLevelTransition == YES){
//            arViewController.newLevelTransition = YES;
//        }
//        
//        [self.navigationController pushViewController:arViewController animated:NO];
//        
//    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"ViewController viewWillAppear");


   
//        [arViewController release];
//        [vc release]; // don't leak memory

        
//        NSLog(@"OH it's a new level alright");
//        ViewController * app = [[[ViewController alloc]init] autorelease];
//        app.title = @"Frame Markers";
//        app.viewControllerClassName = @"FrameMarkersViewController";
//        app.aboutPageName = @"FM_about";
//        
//        Class vcClass = NSClassFromString(@"FrameMarkersViewController");
//        id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
//        
//        UIWindow *window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//        window.rootViewController = self;
//        [window makeKeyAndVisible];
//        window.backgroundColor = [UIColor whiteColor];
//        
//        ARViewController *arViewController = [[ARViewController alloc] initWithRootViewController:vc];
//        
//        [self presentViewController:arViewController animated:NO completion:nil];
//        //        [arViewController release];
//        //        [vc release]; // don't leak memory
//        
//        //        arViewController.newLevelTransition = YES;



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

#pragma mark- Game Center


-(void)multiplayerPressed{
    //Game Kit/Matchmaking
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAuthenticated)
                                                 name:LocalPlayerIsAuthenticated object:nil];
    [[GameKitHelper sharedGameKitHelper]
     authenticateLocalPlayer];

    
}

- (void)playerAuthenticated {
//    
//    SKView *skView = (SKView*)self.view;
//    GameScene *scene = (GameScene*)skView.scene;
    
    _networkingEngine = [[MultiplayerNetworking alloc] init];
    _networkingEngine.delegate = self;
//    scene.networkingEngine = _networkingEngine;
    [[GameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:4 viewController:self delegate:_networkingEngine];
}

- (void)showAuthenticationViewController
{
    GameKitHelper *gameKitHelper =
    [GameKitHelper sharedGameKitHelper];
    
    [self presentViewController:
     gameKitHelper.authenticationViewController animated:YES completion:nil];

}


#pragma mark GameKitHelperDelegate

- (void)matchStarted {
    NSLog(@"Match started");
}

- (void)matchEnded {
    NSLog(@"Match ended");
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"Received data");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- Matchmaking
-(void)startMatchmaking{
     GKMatchRequest *request = [[GKMatchRequest alloc] init];
     request.minPlayers = 2;
     request.maxPlayers = 4;
     
     GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
     mmvc.matchmakerDelegate = self;
     
     [self presentViewController:mmvc animated:YES completion:nil];
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // Implement any specific code in your game here.
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // Implement any specific code in your game here.
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [self dismissViewControllerAnimated:YES completion:nil];

}



#pragma mark MultiplayerNetworkingProtocol

- (void)setCurrentPlayerIndex:(NSUInteger)index {
    _currentPlayerIndex = index;
    NSLog(@"Current Player Index: %lu", index);
    if(index == 0){
        
        SavedLevelsViewController *levelsVC = [[SavedLevelsViewController alloc] init];
        levelsVC.modalPresentationStyle = UIModalPresentationFormSheet;
        levelsVC.matchmaking = YES;
        [self.navigationController presentViewController:levelsVC animated:NO completion:nil];
    }
}

-(void)startLevelWithDict:(NSDictionary *)levelDictionary{
    if(_currentPlayerIndex != 0){
        GameSceneViewController *gameViewController = [[GameSceneViewController alloc] initWithNibName:nil bundle:nil];
        NSMutableDictionary *objDict = [[NSMutableDictionary alloc] initWithDictionary:levelDictionary];
        NSLog(@"Start Level With Object Dict: %@", objDict);
        gameViewController.objectInfoDictionary = objDict;
        gameViewController.playerNumber = _currentPlayerIndex;
        [self.navigationController presentViewController:gameViewController animated:NO completion:^{
//            gameViewController.objectInfoDictionary = objDict;
//            NSLog(@"Gamecontrollerendod %@", gameViewController.objectInfoDictionary);

        }];
    }
    
}

- (void)movePlayerAtIndex:(NSUInteger)index {
   // [_players[index] moveForward];
}

- (void)gameOver:(BOOL)player1Won {
    BOOL didLocalPlayerWin = YES;
    if (player1Won) {
        didLocalPlayerWin = NO;
    }
    if (self.gameOverBlock) {
        self.gameOverBlock(didLocalPlayerWin);
    }
}

-(void)startGame{
    NSLog(@"Start Game Dict:%@", self.multiplayerObjectDictionary);
    NSLog(@"Self:%@", self);
    NSLog(@"VC:%@", self.navigationController.viewControllers);
    [self.navigationController performSelector:@selector(presentLevel) withObject:nil afterDelay:0.0];
}

-(void)presentLevel{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    GameSceneViewController *gameSceneController = [[GameSceneViewController alloc] initWithNibName:nil bundle:nil];
    gameSceneController.objectInfoDictionary = self.multiplayerObjectDictionary;
    window.rootViewController = gameSceneController;
    [window makeKeyAndVisible];
    [self.navigationController presentViewController:gameSceneController animated:NO completion:nil];
    
}

- (void)setPlayerAliases:(NSArray*)playerAliases {
    [playerAliases enumerateObjectsUsingBlock:^(NSString *playerAlias, NSUInteger idx, BOOL *stop) {
       // [_players[idx] setPlayerAliasText:playerAlias];
    }];
}


- (BOOL)shouldAutorotate
{
    return NO;
}


@end
