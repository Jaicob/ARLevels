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

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.skView = (SKView *)self.view;
    self.skView.showsPhysics = YES;
    self.skView.backgroundColor = [UIColor blueColor];
    //
    // Create and configure the scene.
    self.scene = [GameScene sceneWithSize:CGSizeMake(self.skView.bounds.size.width, self.skView.bounds.size.height)];
    NSLog(@"SKView resize frame: %@", NSStringFromCGRect(self.skView.frame));
    self.scene.objectInfoDictionary = self.objectInfoDictionary;
    self.scene.frameVc = self.frameViewController;
    self.scene.delegate = self;
    [self.skView presentScene:self.scene];
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
//    Class vcClass = NSClassFromString(@"FrameMarkersViewController");
//    id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
    
//    [self.navigationController presentViewController:vc animated:NO completion:^{
//        dispatch_after(0, dispatch_get_main_queue(), ^{
//            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
//        });
//    }];
//    
//    [self presentViewController:vc animated:NO completion:^{
//        dispatch_after(0, dispatch_get_main_queue(), ^{
//        [self dismissViewControllerAnimated:NO completion:nil];
//        });
//    }];
    
    
    ViewController *vc = [[ViewController alloc] init];//itWithNibName:@"ViewController" bundle:nil] autorelease];
    vc.newLevelTransition = YES;
    [self presentViewController:vc animated:NO completion:^{
//        dispatch_after(0, dispatch_get_main_queue(), ^{
//        [self dismissViewControllerAnimated:NO completion:nil];
//        });
    }];
    
//    [self dismissViewControllerAnimated:NO completion:^{
////        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        // Override point for customization after application launch.
//
//        
////        UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
////        nc.navigationBar.barStyle = UIBarStyleDefault;
//        
////        self.window.rootViewController = nc;
////        [self.window makeKeyAndVisible];
////        self.window.backgroundColor = [UIColor clearColor];
//        [self presentViewController:vc animated:NO completion:nil];
////        self.scene = nil;
////        [self.scene removeFromParent];
////        [self.skView presentScene:nil];
//        [self.skView.scene removeFromParent];
//    }];

    
//    ViewController* app = [[[ViewController alloc]init] autorelease];
//    app.title = @"Frame Markers";
//    app.viewControllerClassName = @"FrameMarkersViewController";
//    app.aboutPageName = @"FM_about";
//    
//    Class vcClass = NSClassFromString(@"FrameMarkersViewController");
//    id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
//    
//    UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
//    nc.navigationBar.barStyle = UIBarStyleDefault;
//    UIWindow *window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    window.rootViewController = nc;
//    [window makeKeyAndVisible];
//    window.backgroundColor = [UIColor whiteColor];
//    UIView *view = self.frameView;
//    view.frame = self.view.bounds;
//    [self.view addSubview:view];
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
//    [self.scene removeFromParent];
//    [self.skView presentScene:nil];
//    [self.skView.scene removeFromParent];
//    [self.navigationController presentViewController:arViewController animated:NO completion:^{
//      //  [arViewController initWithRootViewController:vc];
//        [self dismissViewControllerAnimated:NO completion:nil];
//
//
//    }];

}

@end
