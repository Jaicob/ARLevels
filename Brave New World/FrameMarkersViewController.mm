/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#import "AppDelegate.h"
#import "FrameMarkersViewController.h"
#import <QCAR/QCAR.h>
#import <QCAR/TrackerManager.h>
#import <QCAR/MarkerTracker.h>
#import <QCAR/DataSet.h>
#import <QCAR/Trackable.h>
#import <QCAR/Marker.h>
#import <QCAR/CameraDevice.h>
#import "GameScene.h"
#import "GameSceneViewController.h"

@interface FrameMarkersViewController ()

@end

@implementation FrameMarkersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        vapp = [[SampleApplicationSession alloc] initWithDelegate:self];
        
        // Custom initialization
        self.title = @"Frame Markers";
        // Create the EAGLView with the screen dimensions
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        viewFrame = screenBounds;
        
        // If this device has a retina display, scale the view bounds that will
        // be passed to QCAR; this allows it to calculate the size and position of
        // the viewport correctly when rendering the video background
        if (YES == vapp.isRetinaDisplay) {
            viewFrame.size.width *= 2.0;
            viewFrame.size.height *= 2.0;
        }
        
        // a single tap will trigger a single autofocus operation
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autofocus:)];
        
        // we use the iOS notification to pause/resume the AR when the application goes (or comeback from) background
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(pauseAR)
         name:UIApplicationWillResignActiveNotification
         object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(resumeAR)
         name:UIApplicationDidBecomeActiveNotification
         object:nil];
        
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            //do portrait work
            NSLog(@"Portrait");
        } else if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
            //do landscape work
            NSLog(@"Landscape");

        }
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [tapGestureRecognizer release];
    
    [vapp release];
    [eaglView release];
    
    [super dealloc];
}

- (void) pauseAR {
    NSError * error = nil;
    if (![vapp pauseAR:&error]) {
        NSLog(@"Error pausing AR:%@", [error description]);
    }
}

- (void) resumeAR {
    NSError * error = nil;
    if(! [vapp resumeAR:&error]) {
        NSLog(@"Error resuming AR:%@", [error description]);
    }
    // on resume, we reset the flash and the associated menu item
    QCAR::CameraDevice::getInstance().setFlashTorchMode(false);
    SampleAppMenu * menu = [SampleAppMenu instance];
    [menu setSelectionValueForCommand:C_FLASH value:false];
}


- (void)loadView
{
    /*// Create the EAGLView
    self.skView = [[SKView alloc] init];
    _skView.showsFPS = YES;
    _skView.showsNodeCount = YES;
    _skView.bounds.size = CGSizeMake(100, 100);
    
    _skView.allowsTransparency = YES;
    _skView.backgroundColor = [UIColor clearColor];
    // Create and configure the scene.
    SKScene * scene = [GameScene sceneWithSize:CGSizeMake(100, 100)];
    scene.backgroundColor = [UIColor clearColor];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    
    eaglView = [[FrameMarkersEAGLView alloc] initWithFrame:viewFrame appSession:vapp];

    // Present the scene.
   // [_skView presentScene:scene];
    [self setView:eaglView];

    
    
    
       // [eaglView addSubview:_skView];
    //[_skView addSubview:eaglView];
   // [self setView:eaglView];
    SampleAppAppDelegate *appDelegate = (SampleAppAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.glResourceHandler = eaglView;
    
    // show loading animation while AR is being initialized
    [self showLoadingAnimation];
    
    // initialize the AR session
    [vapp initAR:QCAR::GL_20 ARViewBoundsSize:viewFrame.size orientation:UIInterfaceOrientationPortrait];*/
    
    eaglView = [[FrameMarkersEAGLView alloc] initWithFrame:viewFrame appSession:vapp];
    [self setView:eaglView];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.glResourceHandler = eaglView;
    
    // show loading animation while AR is being initialized
    [self showLoadingAnimation];
    
    // initialize the AR session
    [vapp initAR:QCAR::GL_20 ARViewBoundsSize:viewFrame.size orientation:UIInterfaceOrientationPortrait];
    
    self.generateLevelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.generateLevelButton.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 + 64,[[UIScreen mainScreen] bounds].size.height/2- 100, 64, 64);
    self.generateLevelButton.transform = CGAffineTransformMakeRotation(-3.14/2);
    [self.generateLevelButton setBackgroundImage:[UIImage imageNamed:@"greyCheckmark.png"] forState:UIControlStateNormal];
    [self.generateLevelButton addTarget:self action:@selector(transition) forControlEvents:UIControlEventTouchUpInside];
    self.generateLevelButton.enabled = NO;
    [eaglView addSubview:self.generateLevelButton];
    eaglView.generateLevelButton = self.generateLevelButton;
    
    
//    self.skView = [[SKView alloc] init];
//    self.skView.showsFPS = YES;
//    self.skView.showsNodeCount = YES;
//    self.skView.bounds.size = CGSizeMake(100, 100);
    
    //self.skView.allowsTransparency = YES;
    //self.skView.backgroundColor = [UIColor clearColor];
    
    // Create and configure the scene.
//    SKScene * scene = [GameScene sceneWithSize:CGSizeMake(100, 100)];
//    scene.backgroundColor = [UIColor clearColor];
//    scene.scaleMode = SKSceneScaleModeResizeFill;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareMenu];

    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    NSLog(@"self.navigationController.navigationBarHidden: %s", self.navigationController.navigationBarHidden ? "Yes" : "No");
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
   /* self.skView = [[SKView alloc] init];
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    self.skView.bounds.size = CGSizeMake(100, 100);
    
    self.skView.allowsTransparency = YES;
    self.skView.backgroundColor = [UIColor clearColor];
    // Create and configure the scene.
    SKScene * scene = [GameScene sceneWithSize:CGSizeMake(100, 100)];
    scene.backgroundColor = [UIColor clearColor];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    // Present the scene.
    [eaglView addSubview:_skView];
    [self.skView presentScene:scene];*/
    
    self.generateLevelButton.enabled = NO;
    [self.generateLevelButton setBackgroundImage:[UIImage imageNamed:@"greyCheckmark"] forState:UIControlStateNormal];
}

- (UIImage *)drawGlToImage
{
    // Draw OpenGL data to an image context
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    
    unsigned char buffer[320 * 480 * 4];
    
    CGContextRef aContext = UIGraphicsGetCurrentContext();
    
    glReadPixels(0, 0, 320, 480, GL_RGBA, GL_UNSIGNED_BYTE, &buffer);
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, &buffer, 320 * 480 * 4, NULL);
    
    CGImageRef iref = CGImageCreate(320,480,8,32,320*4, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaLast, ref, NULL, true, kCGRenderingIntentDefault);
    
    CGContextScaleCTM(aContext, 1.0, -1.0);
    CGContextTranslateCTM(aContext, 0, -self.view.frame.size.height);
    
    UIImage *im = [[UIImage alloc] initWithCGImage:iref];
    
    UIGraphicsEndImageContext();
    
    return im;
}

-(void)transition{
    
        self.view = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.skView = (SKView *)self.view;

    //    self.skView.showsFPS = NO;
    //    self.skView.showsNodeCount = NO;
        self.skView.showsPhysics = YES;
        
        self.skView.allowsTransparency = YES;
        self.skView.backgroundColor = [UIColor clearColor];
        
        // Create and configure the scene.
        GameScene * scene = [GameScene sceneWithSize:CGSizeMake(self.skView.bounds.size.width, self.skView.bounds.size.height)];
        //scene.scaleMode = SKSceneScaleModeAspectFit;
        NSLog(@"SKView resize frame: %@", NSStringFromCGRect(self.skView.frame));
        scene.backgroundImage = eaglView.backgroundImage;
        scene.objectInfoDictionary = eaglView.finalObjectInfoDictionary;
        scene.frameVc = self;
        // Present the scene.
        
        [self.skView presentScene:scene];
        
        didTransition = YES;


}

- (void)newLevel:(id)sender
{

    [self.skView presentScene:nil];
    [self.skView.scene removeFromParent];
    eaglView.pictureTaken = NO;
    eaglView.generateLevelButton.enabled = NO;
    [eaglView.generateLevelButton setBackgroundImage:[UIImage imageNamed:@"greyCheckmark.png"] forState:UIControlStateNormal];
    didTransition = NO;
    [eaglView.objectInfoDictionary removeAllObjects];
    self.view = eaglView;
}


//-(BOOL)shouldAutorotate
//{
//
//}
//
//-(NSUInteger)supportedInterfaceOrientations
//{
//
//}


-(UIImage*) glToUIImage

{
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    CGRect s;
    
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
        
        s = CGRectMake(0, 0, 1024.0f * scale, (768.0f) * scale);
    
    else
        
        s = CGRectMake(0, 0, (320.0f) * scale, 480.0f * scale);
    
    uint8_t *buffer = (uint8_t *) malloc(s.size.width * s.size.height * 4);
    
    glReadPixels(0, 0, s.size.width, s.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, buffer, s.size.width * s.size.height * 4, NULL);
    
    CGImageRef iref = CGImageCreate(s.size.width, s.size.height, 8, 32, s.size.width * 4, CGColorSpaceCreateDeviceRGB(),
                                    
                                    kCGBitmapByteOrderDefault, ref, NULL, true, kCGRenderingIntentDefault);
    
    size_t width = CGImageGetWidth(iref);
    
    size_t height = CGImageGetHeight(iref);
    
    size_t length = width * height * 4;
    
    uint32_t *pixels = (uint32_t *)malloc(length);
    
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * 4,
                                                 
                                                 CGImageGetColorSpace(iref), kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
    
    CGImageRef outputRef = CGBitmapContextCreateImage(context);
    
    UIImage* outputImage = [[UIImage alloc] initWithCGImage:outputRef scale:(CGFloat)1.0 orientation:UIImageOrientationLeft];
    
    CGDataProviderRelease(ref);
    
    CGImageRelease(iref);
    
    CGContextRelease(context);
    
    CGImageRelease(outputRef);
    
    free(pixels);
    
    free(buffer);
    
    NSLog(@"Screenshot size: %d, %d", (int)[outputImage size].width, (int)[outputImage size].height);
    
    return outputImage;
    
}


-(void)captureToPhotoAlbum {
    UIImage *image = [self glToUIImage];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

-(void)snapUIImage
{
    int s = 1;
    UIScreen* screen = [ UIScreen mainScreen ];
    if ( [ screen respondsToSelector:@selector(scale) ] )
        s = (int) [ screen scale ];
    
    const int w = self.view.frame.size.width;
    const int h = self.view.frame.size.height;
    const NSInteger myDataLength = w * h * 4 * s * s;
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, w*s, h*s, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < h*s; y++)
    {
        memcpy( buffer2 + (h*s - 1 - y) * w * 4 * s, buffer + (y * 4 * w * s), w * 4 * s );
    }
    free(buffer); // work with the flipped buffer, so get rid of the original one.
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w * s;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w*s, h*s, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    // then make the uiimage from that
    UIImage *myImage = [ UIImage imageWithCGImage:imageRef scale:s orientation:UIImageOrientationUp ];
    UIImageWriteToSavedPhotosAlbum( myImage, nil, nil, nil );
    CGImageRelease( imageRef );
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpaceRef);
    free(buffer2);
}

- (void)viewWillDisappear:(BOOL)animated {
    // cleanup menu
    [[SampleAppMenu instance]clear];

    [vapp stopAR:nil];
    // Be a good OpenGL ES citizen: now that QCAR is paused and the render
    // thread is not executing, inform the root view controller that the
    // EAGLView should finish any OpenGL ES commands
    [eaglView finishOpenGLESCommands];
	
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.glResourceHandler = nil;
	
    [super viewWillDisappear:animated];

}

- (void)finishOpenGLESCommands
{
    // Called in response to applicationWillResignActive.  Inform the EAGLView
    [eaglView finishOpenGLESCommands];
}


- (void)freeOpenGLESResources
{
    // Called in response to applicationDidEnterBackground.  Inform the EAGLView
    [eaglView freeOpenGLESResources];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
#pragma mark - loading animation

- (void) showLoadingAnimation {
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    CGRect indicatorBounds = CGRectMake(mainBounds.size.width / 2 - 12,
                                        mainBounds.size.height / 2 - 12, 24, 24);
    UIActivityIndicatorView *loadingIndicator = [[[UIActivityIndicatorView alloc]
                                                  initWithFrame:indicatorBounds]autorelease];
    
    loadingIndicator.tag  = 1;
    loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [eaglView addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    
    
}

- (void) hideLoadingAnimation {
    UIActivityIndicatorView *loadingIndicator = (UIActivityIndicatorView *)[eaglView viewWithTag:1];
    [loadingIndicator removeFromSuperview];
    
}
#pragma mark - SampleApplicationControl

// Initialize the application trackers        
- (bool) doInitTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    
    
    // Marker Tracker...
    QCAR::Tracker* trackerBase = trackerManager.initTracker(QCAR::MarkerTracker::getClassType());
    if (trackerBase == NULL)
    {
        NSLog(@"Failed to initialize MarkerTracker.");
        return NO;
    }
    // Create the markers required
    QCAR::MarkerTracker* markerTracker = static_cast<QCAR::MarkerTracker*>(trackerBase);
    if (markerTracker == NULL)
    {
        NSLog(@"Failed to get MarkerTracker.");
        return NO;
    }
    
    // Create frame markers:
    if (!markerTracker->createFrameMarker(0, "MarkerGround0", QCAR::Vec2F(50,50)) ||
        !markerTracker->createFrameMarker(1, "MarkerGround1", QCAR::Vec2F(50,50)) ||
        !markerTracker->createFrameMarker(2, "MarkerGround2", QCAR::Vec2F(50,50)) ||
        !markerTracker->createFrameMarker(3, "MarkerGround3", QCAR::Vec2F(50,50)) ||
        !markerTracker->createFrameMarker(4, "MarkerGold", QCAR::Vec2F(50,50)) ||
        !markerTracker->createFrameMarker(5, "MarkerPlayerStart", QCAR::Vec2F(50,50)) ||
        !markerTracker->createFrameMarker(6, "MarkerPlatform", QCAR::Vec2F(50,50)) ||
        !markerTracker->createFrameMarker(7, "MarkerPlatform2", QCAR::Vec2F(50,50)) ||
        !markerTracker->createFrameMarker(8, "MarkerEnemy1", QCAR::Vec2F(50,50))
        )
        
    {
        NSLog(@"Failed to create frame markers.");
        return NO;
    }
    return YES;
}

// load the data associated to the trackers
- (bool) doLoadTrackersData {
    return YES;
}

// start the application trackers
- (bool) doStartTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker* tracker = trackerManager.getTracker(QCAR::MarkerTracker::getClassType());
    if(tracker == 0) {
        return NO;
    }
    tracker->start();
    return YES;
}

// callback called when the initailization of the AR is done
- (void) onInitARDone:(NSError *)initError {

    [self hideLoadingAnimation];
    
    if (initError == nil) {
        NSError * error = nil;
        [vapp startAR:QCAR::CameraDevice::CAMERA_BACK error:&error];
        
        // by default, we try to set the continuous auto focus mode
        // and we update menu to reflect the state of continuous auto-focus
        bool isContinuousAutofocus = QCAR::CameraDevice::getInstance().setFocusMode(QCAR::CameraDevice::FOCUS_MODE_CONTINUOUSAUTO);
        SampleAppMenu * menu = [SampleAppMenu instance];
        [menu setSelectionValueForCommand:C_AUTOFOCUS value:isContinuousAutofocus];
        

    } else {
        NSLog(@"Error initializing AR:%@", [initError description]);
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[initError localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        });
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kMenuDismissViewController" object:nil];
}

// update from the QCAR loop
- (void) onQCARUpdate: (QCAR::State *) state {
}

// stop your trackerts
- (bool) doStopTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    QCAR::Tracker* tracker = trackerManager.getTracker(QCAR::MarkerTracker::getClassType());
    if(tracker != 0) {
        tracker->stop();
    }
    return YES;
}

// unload the data associated to your trackers
- (bool) doUnloadTrackersData {
    return YES;
}

// deinitialize your trackers
- (bool) doDeinitTrackers {
    QCAR::TrackerManager& trackerManager = QCAR::TrackerManager::getInstance();
    trackerManager.deinitTracker(QCAR::MarkerTracker::getClassType());
    return YES;
}

- (void)autofocus:(UITapGestureRecognizer *)sender
{
    [self performSelector:@selector(cameraPerformAutoFocus) withObject:nil afterDelay:.4];
}

- (void)cameraPerformAutoFocus
{
    QCAR::CameraDevice::getInstance().setFocusMode(QCAR::CameraDevice::FOCUS_MODE_TRIGGERAUTO);
}

#pragma mark - left menu

typedef enum {
    C_AUTOFOCUS,
    C_FLASH,
    C_CAMERA_FRONT,
    C_CAMERA_REAR
} MENU_COMMAND;

- (void) prepareMenu {
    
    SampleAppMenu * menu = [SampleAppMenu prepareWithCommandProtocol:self title:@"Frame Markers"];
    SampleAppMenuGroup * group;
    
    group = [menu addGroup:@""];
    [group addTextItem:@"Vuforia Samples" command:-1];

    group = [menu addGroup:@""];
    [group addSelectionItem:@"Autofocus" command:C_AUTOFOCUS isSelected:NO];
    [group addSelectionItem:@"Flash" command:C_FLASH isSelected:NO];

    group = [menu addSelectionGroup:@"CAMERA"];
    [group addSelectionItem:@"Front" command:C_CAMERA_FRONT isSelected:NO];
    [group addSelectionItem:@"Rear" command:C_CAMERA_REAR isSelected:YES];
}

- (bool) menuProcess:(SampleAppMenu *) menu command:(int) command value:(bool) value{
    bool result = true;
    NSError * error = nil;

    switch(command) {
        case C_FLASH:
            if (!QCAR::CameraDevice::getInstance().setFlashTorchMode(value)) {
                result = false;
            }
            break;
            
        case C_CAMERA_FRONT:
        case C_CAMERA_REAR: {
            if ([vapp stopCamera:&error]) {
                result = [vapp startAR:(command == C_CAMERA_FRONT) ? QCAR::CameraDevice::CAMERA_FRONT:QCAR::CameraDevice::CAMERA_BACK error:&error];
            } else {
                result = false;
            }
            if (result) {
                // if the camera switch worked, the flash will be off
                [menu setSelectionValueForCommand:C_FLASH value:false];
            }

        }
            break;
            
        case C_AUTOFOCUS: {
            int focusMode = (YES == value) ? QCAR::CameraDevice::FOCUS_MODE_CONTINUOUSAUTO : QCAR::CameraDevice::FOCUS_MODE_NORMAL;
            result = QCAR::CameraDevice::getInstance().setFocusMode(focusMode);
        }
            break;
        default:
            result = false;
            break;
    }
    return result;
}

@end

