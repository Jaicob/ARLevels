//
//  GameSceneViewController.m
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "GameSceneViewController.h"

@interface GameSceneViewController () <SKSceneDelegate>
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * aboutPageName;
@property (nonatomic, copy) NSString * viewControllerClassName;
@end

@implementation GameSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{

    // Present the scene.
    
    GameKitHelper *gameKitHelper =
    [GameKitHelper sharedGameKitHelper];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"GameSceneController Dict:%@", self.objectInfoDictionary);
    self.view = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.skView = (SKView *)self.view;
    self.skView.showsPhysics = YES;
    self.skView.backgroundColor = [UIColor blueColor];
    //
    // Create and configure the scene.
    self.scene = [GameScene sceneWithSize:CGSizeMake(self.skView.bounds.size.width, self.skView.bounds.size.height)];
    if(self.isMultiplayer){
        self.scene.isMultiplayer = YES;
    }
    NSLog(@"SKView resize frame: %@", NSStringFromCGRect(self.skView.frame));
    self.scene.objectInfoDictionary = self.objectInfoDictionary;
    self.scene.frameVc = self.frameViewController;
    self.scene.delegate = self;
    self.scene.playerNumber = self.playerNumber;
    [self.skView presentScene:self.scene];
    
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)presentARViewController{
    NSLog(@"IT's happening!");
    [self.skView presentScene:nil];
    [self.scene removeFromParent];
    [self.skView.scene removeFromParent];

    AppDelegate *delegate = [[AppDelegate alloc] init];

//    ViewController *viewController = [[ViewController alloc] init];
//    delegate.nc.view.window.rootViewController = viewController;
//    delegate.window.rootViewController = viewController;
//
//    [self presentViewController:viewController animated:NO completion:nil];
//    delegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    ViewController *vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    vc.newLevelTransition = YES;
    

//    delegate.window.rootViewController = vc;
    delegate.nc = [[UINavigationController alloc]initWithRootViewController:vc];
//    delegate.nc.navigationBar.barStyle = UIBarStyleDefault;
//    
//    delegate.window.rootViewController = delegate.nc;
//    [delegate.window makeKeyAndVisible];
//    delegate.window.backgroundColor = [UIColor blueColor];
    NSLog(@"View Controllers:%@", delegate.nc.viewControllers);
    NSLog(@"Delegate RVC:%@", delegate.window.rootViewController);

    [self presentViewController:delegate.nc animated:NO completion:^{
        [self dismissViewControllerAnimated:NO completion:nil];
    }];

//
//    self.scene = nil;
//    [self.scene removeFromParent];
//    [self.skView presentScene:nil];
//    [self.skView.scene removeFromParent];
    
//    [self presentViewController:self.frameViewController animated:NO completion:nil];
//
//    
//    ARViewController *arViewController = [[ARViewController alloc]initWithRootViewController:vc];
//    arViewController.newLevel = YES;
//    
//    UIWindow *window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    // Override point for customization after application launch.
//    UIViewController *vc = [[ViewController alloc] init];//initWithNibName:@"ViewController" bundle:nil] autorelease];
//    
//    UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
//    nc.navigationBar.barStyle = UIBarStyleDefault;
//    
//    window.rootViewController = nc;
//    [window makeKeyAndVisible];
//    window.backgroundColor = [UIColor whiteColor];
//
//    ViewController *viewController = [[ViewController alloc] init];
    
//    [self dismissViewControllerAnimated:NO completion:^{
//        [self removeFromParentViewController];
//    }];
//
    
//    self.scene = nil;

//    [self.navigationController presentViewController:arViewController animated:NO completion:^{
//      //  [arViewController initWithRootViewController:vc];
//        [self dismissViewControllerAnimated:NO completion:nil];
//
//
//    }];

}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)goBack{
    [self.skView presentScene:nil];
    [self.scene removeFromParent];
    [self.skView.scene removeFromParent];
    ViewController *vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    vc.newLevelTransition = YES;
    [self presentViewController:vc animated:NO completion:nil];

}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}
@end
