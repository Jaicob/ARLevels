/*===============================================================================
Copyright (c) 2012-2014 Qualcomm Connected Experiences, Inc. All Rights Reserved.

Vuforia is a trademark of QUALCOMM Incorporated, registered in the United States 
and other countries. Trademarks of QUALCOMM Incorporated are used with permission.
===============================================================================*/

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <sys/time.h>

#import <QCAR/QCAR.h>
#import <QCAR/State.h>
#import <QCAR/Tool.h>
#import <QCAR/Renderer.h>
#import <QCAR/TrackableResult.h>
#import <QCAR/VideoBackgroundConfig.h>
#import <QCAR/MarkerResult.h>
#import <QCAR/Trackable.h>
#import <QCAR/Tracker.h>
#import <QCAR/TrackerManager.h>

#import "VuforiaObject3D.h"

#import "A_object.h"
#import "C_object.h"
#import "Q_object.h"
#import "R_object.h"
#import "Cube.h"

#import "FrameMarkersEAGLView.h"
#import "Texture.h"
#import "SampleApplicationUtils.h"
#import "SampleApplicationShaderUtils.h"



//******************************************************************************
// *** OpenGL ES thread safety ***
//
// OpenGL ES on iOS is not thread safe.  We ensure thread safety by following
// this procedure:
// 1) Create the OpenGL ES context on the main thread.
// 2) Start the QCAR camera, which causes QCAR to locate our EAGLView and start
//    the render thread.
// 3) QCAR calls our renderFrameQCAR method periodically on the render thread.
//    The first time this happens, the defaultFramebuffer does not exist, so it
//    is created with a call to createFramebuffer.  createFramebuffer is called
//    on the main thread in order to safely allocate the OpenGL ES storage,
//    which is shared with the drawable layer.  The render (background) thread
//    is blocked during the call to createFramebuffer, thus ensuring no
//    concurrent use of the OpenGL ES context.
//
//******************************************************************************


namespace {
    // --- Data private to this unit ---
    // Letter object scale factor and translation
    const float kLetterScale = 25.0f;
    const float kLetterTranslate = 0.0f;
    
    QCAR::Vec3F targetCumulatedDisplacement(0.0f, 0.0f, 0.0f);
    
    // Texture filenames
    const char* textureFilenames[] = {
        "groundTexture.png",
        "groundTexture.png",
        "groundTexture.png",
        "groundTexture.png",
        "goldTexture.png",
        "redCubeTexture.png",
        "platformTexture.png",
        "platformTexture2.png",
        "enemy1Texture.png"
    };
}


@interface FrameMarkersEAGLView (PrivateMethods)

- (void)initShaders;
- (void)createFramebuffer;
- (void)deleteFramebuffer;
- (void)setFramebuffer;
- (BOOL)presentFramebuffer;

@end


@implementation FrameMarkersEAGLView

// You must implement this method, which ensures the view's underlying layer is
// of type CAEAGLLayer
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


//------------------------------------------------------------------------------
#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame appSession:(SampleApplicationSession *) app
{
    NSLog(@"VIEW INITED WITH FRAME");
    self = [super initWithFrame:frame];
    
    if (self) {
        vapp = app;
        // Enable retina mode if available on this device
        if (YES == [vapp isRetinaDisplay]) {
            [self setContentScaleFactor:2.0f];
        }
        
        objects3D = [[NSMutableArray alloc] initWithCapacity:NUM_AUGMENTATION_TEXTURES];

        // Load the augmentation textures
        for (int i = 0; i < NUM_AUGMENTATION_TEXTURES; ++i) {
            augmentationTexture[i] = [[Texture alloc] initWithImageFile:[NSString stringWithCString:textureFilenames[i] encoding:NSASCIIStringEncoding]];
        }

        // Create the OpenGL ES context
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        // The EAGLContext must be set for each thread that wishes to use it.
        // Set it the first time this method is called (on the main thread)
        if (context != [EAGLContext currentContext]) {
            [EAGLContext setCurrentContext:context];
        }
        
        // Generate the OpenGL ES texture and upload the texture data for use
        // when rendering the augmentation
        for (int i = 0; i < NUM_AUGMENTATION_TEXTURES; ++i) {
            GLuint textureID;
            glGenTextures(1, &textureID);
            [augmentationTexture[i] setTextureID:textureID];
            glBindTexture(GL_TEXTURE_2D, textureID);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [augmentationTexture[i] width], [augmentationTexture[i] height], 0, GL_RGBA, GL_UNSIGNED_BYTE, (GLvoid*)[augmentationTexture[i] pngData]);
        }
        [self setup3dObjects];
        
        offTargetTrackingEnabled = NO;

        [self initShaders];
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.button setImage:[UIImage imageNamed:@"camera-96.png"] forState:UIControlStateNormal];
        //self.button.backgroundColor = [UIColor colorWithRed:(2.00f/255.00f) green:(186.00f/255.00f) blue:(242.00f/255.00f) alpha:1.0f];
        self.button.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2 + 64,[[UIScreen mainScreen] bounds].size.height/2- 32, 64, 64);
        self.button.transform = CGAffineTransformMakeRotation(-3.14/2);
//        self.button.layer.cornerRadius = self.button.frame.size.height/2;
//        self.button.layer.masksToBounds = YES;
//        self.button.layer.borderWidth = 0;
        self.pictureTaken = NO;
        NSLog(@"We'll reset the picture taken %d", self.pictureTaken);
        [self.button addTarget:self action:@selector(saveBackgroundImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        tempButtonsArray = [[NSMutableArray alloc] init];

        if(!self.objectInfoDictionary){
            self.objectInfoDictionary = [[NSMutableDictionary alloc] init];
        }
        
    }
    
    return self;
}


-(void)captureToPhotoAlbum {
    UIImage *image = [self glToUIImage];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

- (void)dealloc
{
    [self deleteFramebuffer];
    
    // Tear down context
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];

    for (int i = 0; i < NUM_AUGMENTATION_TEXTURES; ++i) {
        [augmentationTexture[i] release];
    }

    [super dealloc];
}


- (void)finishOpenGLESCommands
{
    // Called in response to applicationWillResignActive.  The render loop has
    // been stopped, so we now make sure all OpenGL ES commands complete before
    // we (potentially) go into the background
    if (context) {
        [EAGLContext setCurrentContext:context];
        glFinish();
    }
}


- (void)freeOpenGLESResources
{
    // Called in response to applicationDidEnterBackground.  Free easily
    // recreated OpenGL ES resources
    [self deleteFramebuffer];
    glFinish();
}


- (void) add3DObjectWith:(int)numVertices ofVertices:(const float *)vertices normals:(const float *)normals texcoords:(const float *)texCoords with:(int)numIndices ofIndices:(const unsigned short *)indices usingTextureIndex:(NSInteger)textureIndex
{
    VuforiaObject3D *obj3D = [[VuforiaObject3D alloc] init];
    
    obj3D.numVertices = numVertices;
    obj3D.vertices = vertices;
    obj3D.normals = normals;
    obj3D.texCoords = texCoords;
    
    obj3D.numIndices = numIndices;
    obj3D.indices = indices;
    
    obj3D.texture = augmentationTexture[textureIndex];
    
    [objects3D addObject:obj3D];
    [obj3D release];
    
}

-(void)moveLeft{
    for(VuforiaObject3D *obj3D in objects3D){
        
    }
}

- (void) setup3dObjects
{
    // build the array of objects we want drawn and their texture
    // in this example we have 4 textures and 4 objects - Q, C, A, R
    for (int i = 0; i < NUM_AUGMENTATION_TEXTURES; ++i) {
        [self add3DObjectWith:NUM_CUBE_VERTEX ofVertices:cubeVertices normals:cubeNormals texcoords:cubeTexCoords
                         with:NUM_CUBE_INDEX ofIndices:cubeIndices usingTextureIndex:i];
    }
}

- (void) setOffTargetTrackingMode:(BOOL) enabled {
    offTargetTrackingEnabled = enabled;
}

-(void)saveBackgroundImage
{
    NSLog(@"save background image");
   self.finalObjectInfoDictionary = [[NSMutableDictionary alloc] initWithDictionary:self.objectInfoDictionary];
    NSLog(@"Info Dict:%@", self.objectInfoDictionary);
    NSLog(@"Final Object Dict:%@", self.finalObjectInfoDictionary);

    if([self.finalObjectInfoDictionary objectForKey:@"MarkerPlayerStart"]){
        for(UIButton *button in tempButtonsArray){
            button.alpha = 0.0f;
        }
        
        self.pictureTaken = YES;
        self.generateLevelButton.enabled = YES;
        [self.generateLevelButton setBackgroundImage:[UIImage imageNamed:@"greenCheckmark.png"] forState:UIControlStateNormal];
    //self.backgroundImage = [self glToUIImage];
        for(NSString *key in self.finalObjectInfoDictionary){
            
            CGPoint point = [[self.objectInfoDictionary objectForKey:key] CGPointValue];
            UIButton *markerButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [markerButton setImage:[UIImage imageNamed:@"GEM.png"] forState:UIControlStateNormal];
            markerButton.frame = CGRectMake(point.x, point.y, 30, 30);
            markerButton.transform = CGAffineTransformMakeRotation(-3.14/2);
            [self addSubview:markerButton];
            [tempButtonsArray addObject:markerButton];
        }
//
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait" message:@"Make sure you get the character start square in you photo!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

}

- (UIImage*) glToUIImage

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
    
    UIImage* outputImage = [[UIImage alloc] initWithCGImage:outputRef scale:(CGFloat)1.0 orientation:UIImageOrientationLeftMirrored];
    
    CGDataProviderRelease(ref);
    
    CGImageRelease(iref);
    
    CGContextRelease(context);
    
    CGImageRelease(outputRef);
    
    free(pixels);
    
    free(buffer);  
    
    NSLog(@"Screenshot size: %d, %d", (int)[outputImage size].width, (int)[outputImage size].height);
    
    return outputImage;
    
}


//------------------------------------------------------------------------------
#pragma mark - UIGLViewProtocol methods

// Draw the current frame using OpenGL
//
// This method is called by QCAR when it wishes to render the current frame to
// the screen.
//
// *** QCAR will call this method periodically on a background thread ***
- (void)renderFrameQCAR
{
    [self setFramebuffer];
    bool isFrontCamera = false;
    
    // Clear colour and depth buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Retrieve tracking state and render video background and
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    
    glEnable(GL_DEPTH_TEST);
    // We must detect if background reflection is active and adjust the culling direction.
    // If the reflection is active, this means the pose matrix has been reflected as well,
    // therefore standard counter clockwise face culling will result in "inside out" models.
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    if(QCAR::Renderer::getInstance().getVideoBackgroundConfig().mReflection == QCAR::VIDEO_BACKGROUND_REFLECTION_ON) {
        glFrontFace(GL_CW);  //Front camera
        isFrontCamera = true;
    } else {
        glFrontFace(GL_CCW);   //Back camera
    }
    
    // Did we find any trackables this frame?
    for(int i = 0; i < state.getNumTrackableResults(); ++i) {
        // Get the trackable
        const QCAR::TrackableResult* trackableResult = state.getTrackableResult(i);
        QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(trackableResult->getPose());
        // Check the type of the trackable:
        assert (trackableResult->isOfType(QCAR::MarkerResult::getClassType()));
        const QCAR::MarkerResult* markerResult = static_cast<
        const QCAR::MarkerResult*>(trackableResult);
        const QCAR::Marker& marker = markerResult->getTrackable();

        QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
        const QCAR::CameraCalibration& cameraCalibration = cameraDevice.getCameraCalibration();
        
        //This one works
        QCAR::Vec2F cameraPoint = QCAR::Tool::projectPoint(cameraCalibration, trackableResult->getPose(), QCAR::Vec3F(0,0,0));
        QCAR::Vec2F xyPoint = cameraPointToScreenPoint(cameraPoint);
        float coordX =xyPoint.data[0];
        float coordY = xyPoint.data[1];
        //NSLog(@"(%f, %f)",coordX, coordY);

        CGPoint objectCoord = CGPointMake(coordX, coordY);
        
        const QCAR::TrackableResult* result = state.getTrackableResult(i);
        QCAR::MarkerResult *imageResult = (QCAR::MarkerResult *)result;
        QCAR::Vec2F trackableSize = imageResult->getTrackable().getSize();
        QCAR::Matrix34F pose = result->getPose();
        CGSize targetSize = CGSizeMake(trackableSize.data[0], trackableSize.data[1]);
        CGPoint targetPoint = [self calcScreenCoordsOf:targetSize inPose:pose];
       // NSLog(@"(%f, %f)",targetPoint.x,targetPoint.y);
        
        objectCoord = CGPointMake((coordX + targetPoint.y)/2, (coordY + targetPoint.x)/2);
        
//        //Trying this one
//        const QCAR::TrackerManager& tracker = QCAR::TrackerManager::getInstance();
//        QCAR::Vec2F screenPoint = QCAR::Tool::projectPoint(cameraCalibration, trackableResult->getPose(), QCAR::Vec3F(0, 0, 0));
//        coordX =screenPoint.data[0];
//        coordY = screenPoint.data[1];
//        objectCoord = CGPointMake(coordX, coordY);
       // NSLog(@"ObjectInfo during Render:%@", self.objectInfoDictionary);
        //NSLog(@"%d", self.pictureTaken);
        if(!self.pictureTaken){
            [self.objectInfoDictionary setObject:[NSValue valueWithCGPoint:objectCoord] forKey:[NSString stringWithFormat:@"%s", marker.getName()]];

        }
//        NSLog(@"ObjectCoord:%@, Name:%s",[NSValue valueWithCGPoint:objectCoord], marker.getName());
//        NSLog(@"ObjectInfoDictionary:%@", self.objectInfoDictionary);
        
       // }
        if (trackableResult->getStatus() == QCAR::TrackableResult::EXTENDED_TRACKED) {
            NSLog(@"[%s] tracked with target out of view!", marker.getName());
        }
        
        NSString *markerName = [NSString stringWithFormat:@"[%s]",marker.getName()];
        if([markerName isEqualToString:@"Marker A"]){
        }

        
        // Choose the object and texture based on the marker ID
        int textureIndex = marker.getMarkerId();
        assert(textureIndex < NUM_AUGMENTATION_TEXTURES);
        
        VuforiaObject3D *obj3D = [objects3D objectAtIndex:textureIndex];
        
        
        // Render with OpenGL 2
        QCAR::Matrix44F modelViewProjection;
        SampleApplicationUtils::scalePoseMatrix(1, 1, 1, &modelViewMatrix.data[0]);
        SampleApplicationUtils::translatePoseMatrix(-kLetterTranslate, -kLetterTranslate, 0.f, &modelViewMatrix.data[0]);
        SampleApplicationUtils::scalePoseMatrix(kLetterScale, kLetterScale, kLetterScale, &modelViewMatrix.data[0]);
        SampleApplicationUtils::multiplyMatrix(&vapp.projectionMatrix.data[0], &modelViewMatrix.data[0], &modelViewProjection.data[0]);
        
        glUseProgram(shaderProgramID);
        
        glVertexAttribPointer(vertexHandle, 3, GL_FLOAT, GL_FALSE, 0, obj3D.vertices);
        glVertexAttribPointer(normalHandle, 3, GL_FLOAT, GL_FALSE, 0, obj3D.normals);
        glVertexAttribPointer(textureCoordHandle, 2, GL_FLOAT, GL_FALSE, 0, obj3D.texCoords);
        
        glEnableVertexAttribArray(vertexHandle);
        glEnableVertexAttribArray(normalHandle);
        glEnableVertexAttribArray(textureCoordHandle);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, [obj3D.texture textureID]);
        glUniformMatrix4fv(mvpMatrixHandle, 1, GL_FALSE, (GLfloat*)&modelViewProjection.data[0]);
        glUniform1i(texSampler2DHandle, 0 /*GL_TEXTURE0*/);
        glDrawElements(GL_TRIANGLES, obj3D.numIndices, GL_UNSIGNED_SHORT, obj3D.indices);
        
        SampleApplicationUtils::checkGlError("FrameMarkerss renderFrameQCAR");

        
//        CGFloat w = 580/2;
//        CGFloat h = 580/2;
//        
//        // need to account for the orientation on view size
//        CGFloat viewWidth = self.frame.size.height; // Portrait
//        CGFloat viewHeight = self.frame.size.width; // Portrait
//        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//        if (UIInterfaceOrientationIsLandscape(orientation))
//        {
//            viewWidth = self.frame.size.width;
//            viewHeight = self.frame.size.height;
//        }
//        
//        // calculate any mismatch of screen to video size
//        QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
//        const QCAR::CameraCalibration& cameraCalibration = cameraDevice.getCameraCalibration();
//        QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
//        
//        CGFloat scale = viewWidth/videoMode.mWidth;
//        if (videoMode.mHeight * scale < viewHeight)
//            scale = viewHeight/videoMode.mHeight;
//        CGFloat scaledWidth = videoMode.mWidth * scale;
//        CGFloat scaledHeight = videoMode.mHeight * scale;
//        
//        CGPoint margin = {(scaledWidth - viewWidth)/2, (scaledHeight - viewHeight)/2};
//        
//        CGPoint converted;
//        
//        QCAR::Vec3F vec(coord.x,coord.y,0);
//        QCAR::Vec2F sc = QCAR::Tool::projectPoint(cameraCalibration, trackableResult->getPose(), vec);
//        converted.x = sc.data[0]*scale - margin.x;
//        converted.y = sc.data[1]*scale - margin.y;
        
        
//        const QCAR::CameraCalibration& cameraCalibration = QCAR::CameraDevice::getInstance().getCameraCalibration();
//        QCAR::Vec2F cameraPoint = QCAR::Tool::projectPoint(cameraCalibration, trackableResult->getPose(), QCAR::Vec3F(0, 0, 0));
//        QCAR::VideoMode videoMode = QCAR::CameraDevice::getInstance().getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
//        QCAR::VideoBackgroundConfig config = QCAR::Renderer::getInstance().getVideoBackgroundConfig();
//        
//        int xOffset = ((int) [UIScreen mainScreen].bounds.size.width - config.mSize.data[0]) / 2.0f + config.mPosition.data[0];
//        int yOffset = ((int) [UIScreen mainScreen].bounds.size.height - config.mSize.data[1]) / 2.0f - config.mPosition.data[1];
//        
//        float coordX = QCAR::Vec2F(cameraPoint.data[0] * config.mSize.data[0] / (float) videoMode.mWidth + xOffset,
//                         cameraPoint.data[1] * config.mSize.data[1] / (float) videoMode.mHeight + yOffset).data[0];
//        float coordY = QCAR::Vec2F(cameraPoint.data[0] * config.mSize.data[0] / (float) videoMode.mWidth + xOffset,
//                                  cameraPoint.data[1] * config.mSize.data[1] / (float) videoMode.mHeight + yOffset).data[1];
//        
//        float cameraCoordX = cameraPoint.data[0];
//        float cameraCoordY = cameraPoint.data[1];
//        
//        CGPoint objectCoord = CGPointMake(coordX, coordY);
//        if(!self.pictureTaken){
//            [self.objectInfoDictionary setObject:[NSValue valueWithCGPoint:objectCoord] forKey:[NSString stringWithFormat:@"%s", marker.getName()]];
//            NSLog(@"View X: %f, View Y: %f", coordX, coordY);
//
//            
//        }else{
//
//        }
//        
        
        
        
    }
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    glDisableVertexAttribArray(vertexHandle);
    glDisableVertexAttribArray(normalHandle);
    glDisableVertexAttribArray(textureCoordHandle);
    
    QCAR::Renderer::getInstance().end();
    [self presentFramebuffer];

}

//------------------------------------------------------------------------------
#pragma mark - OpenGL ES management

QCAR::Vec2F cameraPointToScreenPoint(QCAR::Vec2F cameraPoint)
{
    QCAR::VideoMode videoMode = QCAR::CameraDevice::getInstance().getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    QCAR::VideoBackgroundConfig config = QCAR::Renderer::getInstance().getVideoBackgroundConfig();
    

    int xOffset = ((int) [UIScreen mainScreen].bounds.size.width - config.mSize.data[0]) / 2.0f + config.mPosition.data[0];
    int yOffset = ((int)  [UIScreen mainScreen].bounds.size.height - config.mSize.data[1]) / 2.0f - config.mPosition.data[1];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (!UIInterfaceOrientationIsLandscape(orientation))
    {
        // camera image is rotated 90 degrees
        //NSLog(@"This one thinks we're landscape too");
        int rotatedX = videoMode.mHeight - cameraPoint.data[1];
        int rotatedY = cameraPoint.data[0];
        
        return QCAR::Vec2F(rotatedX * config.mSize.data[0] / (float) videoMode.mHeight + xOffset,
                           rotatedY * config.mSize.data[1] / (float) videoMode.mWidth + yOffset);
    }
    else
    {
        NSLog(@"Portrait as well");
        return QCAR::Vec2F(cameraPoint.data[0] * config.mSize.data[0] / (float) videoMode.mWidth + xOffset,
                           cameraPoint.data[1] * config.mSize.data[1] / (float) videoMode.mHeight + yOffset);
    }
}


- (void)initShaders
{
    shaderProgramID = [SampleApplicationShaderUtils createProgramWithVertexShaderFileName:@"Simple.vertsh"
                                                   fragmentShaderFileName:@"Simple.fragsh"];

    if (0 < shaderProgramID) {
        vertexHandle = glGetAttribLocation(shaderProgramID, "vertexPosition");
        normalHandle = glGetAttribLocation(shaderProgramID, "vertexNormal");
        textureCoordHandle = glGetAttribLocation(shaderProgramID, "vertexTexCoord");
        mvpMatrixHandle = glGetUniformLocation(shaderProgramID, "modelViewProjectionMatrix");
        texSampler2DHandle  = glGetUniformLocation(shaderProgramID,"texSampler2D");
    }
    else {
        NSLog(@"Could not initialise augmentation shader");
    }
}

//- (CGPoint) projectCoord:(CGPoint)coord inView:(const QCAR::CameraCalibration&)cameraCalibration andPose:(QCAR::Matrix34F)pose withOffset:(CGPoint)offset andScale:(CGFloat)scale
//{
//    CGPoint converted;
//    
//    QCAR::Vec3F vec(coord.x,coord.y,0);
//    QCAR::Vec2F sc = QCAR::Tool::projectPoint(cameraCalibration, pose, vec);
//    converted.x = sc.data[0]*scale - offset.x;
//    converted.y = sc.data[1]*scale - offset.y;
//    
//    return converted;
//}
//
//- (void) calcScreenCoordsOf:(CGSize)target inView:(CGFloat *)matrix inPose:(QCAR::Matrix34F)pose
//{
//    // 0,0 is at centre of target so extremities are at w/2,h/2
//    CGFloat w = target.width/2;
//    CGFloat h = target.height/2;
//    
//    // need to account for the orientation on view size
//    CGFloat viewWidth = self.frame.size.height; // Portrait
//    CGFloat viewHeight = self.frame.size.width; // Portrait
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (UIInterfaceOrientationIsLandscape(orientation))
//    {
//        NSLog(@"Is Landscape");
//        viewWidth = self.frame.size.width;
//        viewHeight = self.frame.size.height;
//    }
//    NSLog(@"Self frame width:%f height:%f", viewWidth, viewHeight);
//    
//    // calculate any mismatch of screen to video size
//    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
//    const QCAR::CameraCalibration& cameraCalibration = cameraDevice.getCameraCalibration();
//    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
//    
//    CGFloat scale = viewWidth/videoMode.mWidth;
//    if (videoMode.mHeight * scale < viewHeight)
//        scale = viewHeight/videoMode.mHeight;
//    CGFloat scaledWidth = videoMode.mWidth * scale;
//    CGFloat scaledHeight = videoMode.mHeight * scale;
//    
//    CGPoint margin = {(scaledWidth - viewWidth)/2, (scaledHeight - viewHeight)/2};
//    
//    CGPoint point0 = [self projectCoord:CGPointMake(-w,h) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
//    CGPoint point1 = [self projectCoord:CGPointMake(-w,-h) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
//    CGPoint point2 = [self projectCoord:CGPointMake(w,-h) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
//    CGPoint point3 = [self projectCoord:CGPointMake(w,h) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
//    
//    CGPoint center = [self projectCoord:CGPointMake(w/2, h/2) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
//    NSLog(@"Center.x: %f, center.y:%f", center.x, center.y);
//    // now project the 4 corners of the target
////    ImageTargetsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
////    delegate.s0 = [self projectCoord:CGPointMake(-w,h) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
////    delegate.s1 = [self projectCoord:CGPointMake(-w,-h) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
////    delegate.s2 = [self projectCoord:CGPointMake(w,-h) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
////    delegate.s3 = [self projectCoord:CGPointMake(w,h) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
//}

- (CGPoint) projectCoord:(CGPoint)coord inView:(const QCAR::CameraCalibration&)cameraCalibration andPose:(QCAR::Matrix34F)pose withOffset:(CGPoint)offset andScale:(CGFloat)scale
{
    CGPoint converted;
    QCAR::Vec3F vec(coord.x,coord.y,0);
    QCAR::Vec2F sc = QCAR::Tool::projectPoint(cameraCalibration, pose, vec);
    converted.x = sc.data[0]*scale - offset.x;
    converted.y = sc.data[1]*scale - offset.y;
    return converted;
}

- (CGPoint)calcScreenCoordsOf:(CGSize)target inPose:(QCAR::Matrix34F)pose
{
    // need to account for Portrait orientation
    CGFloat viewWidth = self.frame.size.height; // Portrait
    CGFloat viewHeight = self.frame.size.width; // Portrait
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        //NSLog(@"thinks we're in landscape");
        viewWidth = self.frame.size.width;
        viewHeight = self.frame.size.height;
    }
    
    // calculate any mismatch of screen to video size
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    const QCAR::CameraCalibration& cameraCalibration = cameraDevice.getCameraCalibration();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    
    CGFloat scale = viewWidth/videoMode.mWidth;
    if (videoMode.mHeight * scale < viewHeight)
        scale = viewHeight/videoMode.mHeight;
    CGFloat scaledWidth = videoMode.mWidth * scale;
    CGFloat scaledHeight = videoMode.mHeight * scale;
    
    CGPoint margin = {(scaledWidth - viewWidth)/2, (scaledHeight - viewHeight)/2};
    
    CGPoint targetCenter = [self projectCoord:CGPointMake(0,0) inView:cameraCalibration andPose:pose withOffset:margin andScale:scale];
    return targetCenter;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint loc = [touch locationInView:self];
    NSLog(@"X:%f Y:%f touch", loc.x, loc.y);
    
    for(NSString *key in self.objectInfoDictionary){
        CGPoint point = [[self.objectInfoDictionary objectForKey:key] CGPointValue];
        NSLog(@"Virtual x: %f, virtual y:%f", point.x, point.y);
    }
}
- (void)createFramebuffer
{
    if (context) {
        // Create default framebuffer object
        glGenFramebuffers(1, &defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        
        // Create colour renderbuffer and allocate backing store
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        // Allocate the renderbuffer's storage (shared with the drawable object)
        [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
        GLint framebufferWidth;
        GLint framebufferHeight;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        
        // Create the depth render buffer and allocate storage
        glGenRenderbuffers(1, &depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);
        
        // Attach colour and depth render buffers to the frame buffer
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
        
        // Leave the colour render buffer bound so future rendering operations will act on it
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    }
}


- (void)deleteFramebuffer
{
    if (context) {
        [EAGLContext setCurrentContext:context];
        
        if (defaultFramebuffer) {
            glDeleteFramebuffers(1, &defaultFramebuffer);
            defaultFramebuffer = 0;
        }
        
        if (colorRenderbuffer) {
            glDeleteRenderbuffers(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }
        
        if (depthRenderbuffer) {
            glDeleteRenderbuffers(1, &depthRenderbuffer);
            depthRenderbuffer = 0;
        }
    }
}


- (void)setFramebuffer
{
    // The EAGLContext must be set for each thread that wishes to use it.  Set
    // it the first time this method is called (on the render thread)
    if (context != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:context];
    }
    
    if (!defaultFramebuffer) {
        // Perform on the main thread to ensure safe memory allocation for the
        // shared buffer.  Block until the operation is complete to prevent
        // simultaneous access to the OpenGL context
        [self performSelectorOnMainThread:@selector(createFramebuffer) withObject:self waitUntilDone:YES];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
}


- (BOOL)presentFramebuffer
{
    // setFramebuffer must have been called before presentFramebuffer, therefore
    // we know the context is valid and has been set for this (render) thread
    
    // Bind the colour render buffer and present it
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    
    return [context presentRenderbuffer:GL_RENDERBUFFER];
}




@end

