//
//  ARViewController.m
//  Brave New World
//
//  Created by Justin Lennox on 3/24/15.
//  Copyright (c) 2015 Justin Lennox. All rights reserved.
//

#import "ARViewController.h"
#import "ViewController.h"

@interface ARViewController ()

@end

@implementation ARViewController

- (id)initWithRootViewController:(UIViewController*) controller {
    if ((self = [super init])) {
        
        self.rootViewController = controller;
        // the left view controller is the menu associated to the application
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   // [_rootViewController release];
    _rootViewController = nil;
   // [super dealloc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ARView Loaded Baby");
    // add the view associated to the root view controller
//    UIView *view = self.rootViewController.view;
//    view.frame = self.view.bounds;
//    [self.view addSubview:view];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//                UIView *view = self.rootViewController.view;
//                view.frame = self.view.bounds;
//                [self.view addSubview:view];
//                [self.navigationController setNavigationBarHidden:YES animated:NO];
//                NSLog(@"current root view controller:%@, View:%@", self.rootViewController, self.rootViewController.view);

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
        NSLog(@"current root view controller:%@, View:%@", self.rootViewController, self.rootViewController.view);
    UIView *view = self.rootViewController.view;
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

//
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    if(self.rootViewController){
//
//        UIWindow *window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//        // Override point for customization after application launch.
//        UIViewController *vc = [[ViewController alloc] init];//initWithNibName:@"ViewController" bundle:nil] autorelease];
//        
//        UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
//        nc.navigationBar.barStyle = UIBarStyleDefault;
//        
//        window.rootViewController = nc;
//        [window makeKeyAndVisible];
//        window.backgroundColor = [UIColor whiteColor];
//        UIView *view = (UIView *)self.rootViewController.view;
//        view.frame = self.view.bounds;
//        [self.view addSubview:view];
//    }else{
//        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
//        view.frame = self.view.bounds;
//        [self.view addSubview:view];
//    }
//    
//
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//  //  [self showRootController:NO];
//
//}


- (void)showRootController:(BOOL)animated {
    
    self.rootViewController.view.userInteractionEnabled = YES;
    
    CGRect frame = self.rootViewController.view.frame;
    frame.origin.x = 0.0f;
    
    // keep track of the state of the animations
    BOOL animationEnabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    // the animation will position the root view controller to its final frame position
    //[UIView animateWithDuration:ANIMATION_DURATION animations:^{
    self.rootViewController.view.frame = frame;
    //} completion:^(BOOL finished) {
        // at the end, we remove the menu
        // from its superview to make it disappear
       // }
      //  showingLeftMenu = NO;
      //  [self setRootViewControllerShadow:NO];
    //}];
    
    if (!animated) {
        // restore the state of the animations
        [UIView setAnimationsEnabled:animationEnabled];
    }
    
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
