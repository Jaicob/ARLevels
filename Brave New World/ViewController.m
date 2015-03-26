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
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * aboutPageName;
@property (nonatomic, copy) NSString * viewControllerClassName;
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

    // Do any additional setup after loading the view, typically from a nib.
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"View controller did appear Baby");

        ViewController * app = [[[ViewController alloc]init] autorelease];
        app.title = @"Frame Markers";
        app.viewControllerClassName = @"FrameMarkersViewController";
        app.aboutPageName = @"FM_about";
    
        Class vcClass = NSClassFromString(@"FrameMarkersViewController");
        id vc = [[vcClass alloc]  initWithNibName:nil bundle:nil];
        
        ARViewController *slidingMenuController = [[ARViewController alloc] initWithRootViewController:vc];
        
        [self.navigationController pushViewController:slidingMenuController animated:NO];
        [slidingMenuController release];
        [vc release]; // don't leak memory

    
    
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
