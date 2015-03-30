#import <UIKit/UIKit.h>
#import "SampleGLResourceHandler.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nc;
@property (assign, nonatomic) id<SampleGLResourceHandler> glResourceHandler;

@end
