//
//  GameScene.m
//  VuforiaSamples
//
//  Created by Justin Lennox on 3/21/15.
//  Copyright (c) 2015 Qualcomm. All rights reserved.
//

#import "GameScene.h"
#import "customButton.h"
#import <AVFoundation/AVFoundation.h>
#import "SpriteManager.h"


@implementation GameScene

//bit masks
static const int playerHitCategory =  0x1;
static const int playerFeetCategory = 0x10;
static const int groundHitCategory =  0x100;
static const int solidHitCategory =   0x1000;
static const int winLevelCategory =   0x10000;
static const int projectileCategory = 0x100000;


-(void)didMoveToView:(SKView *)view{
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];

    [NSUserDefaults resetStandardUserDefaults];
    self.view.multipleTouchEnabled = YES;
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity=CGVectorMake(6, 0);
    self.backgroundColor = [UIColor whiteColor];
    
    SKTexture *backgroundTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"Background.png"]];
    self.background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:CGSizeMake(720, 420)];
    self.background.position = (CGPoint) {CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame)};
    self.background.zRotation = M_PI/2;
    [self addChild:self.background];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BackgroundTrack" ofType:@"aif"];
    NSError *error;
    self.gameSceneLoop = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
    if (error) {
        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
    } else {
        self.gameSceneLoop.numberOfLoops = -1;
        [self.gameSceneLoop prepareToPlay];
        //[self.gameSceneLoop play];
    }
    
    self.objectsArray = [[NSMutableArray alloc]init];
    
    self.brownButtonArray = [[NSMutableArray alloc] init];
    
    self.userInteractionEnabled = YES;
    NSLog(@"Dictionary: %@", self.objectInfoDictionary);
    

    SpriteManager *spriteManager = [[SpriteManager alloc] init];
    [spriteManager addSpritesToScene:self.scene FromDictionary:self.objectInfoDictionary];
    self.spriteDictionary = spriteManager.spriteDictionary;
    if([self.spriteDictionary objectForKey:@"MarkerEnemy1"]){
        self.enemy1Timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(enemy1Attack) userInfo:nil repeats:YES];
        
    }
    NSLog(@"SpriteDict:%@",self.spriteDictionary);

    self.view.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
#pragma mark- Set Up UI
    //Add UI/End Game Buttons
    SKSpriteNode *rightArrow = [SKSpriteNode spriteNodeWithImageNamed:@"rightArrow.png"];
    rightArrow.size = CGSizeMake(75, 75);
    
    rightArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - rightArrow.size.width/2 - 10, rightArrow.size.height/2 + 100);
    rightArrow.name = @"rightArrow";
    rightArrow.zRotation = M_PI/2;
    rightArrow.zPosition = 5.0f;
    
    [self.scene addChild:rightArrow];
    
    SKSpriteNode *leftArrow = [SKSpriteNode spriteNodeWithImageNamed:@"leftArrow.png"];
    leftArrow.size = CGSizeMake(75, 75);
    leftArrow.position = CGPointMake(CGRectGetMaxX(self.view.frame) - leftArrow.size.width/2 - 10, rightArrow.size.height/2 + 20);
    leftArrow.zRotation = M_PI/2;
    leftArrow.name = @"leftArrow";
    leftArrow.zPosition = 5.0f;
    [self.scene addChild:leftArrow];
    
    SKSpriteNode *upArrow = [SKSpriteNode spriteNodeWithImageNamed:@"upArrow.png"];
    upArrow.size = CGSizeMake(75, 75);
    upArrow .position = CGPointMake(CGRectGetMaxX(self.view.frame) - leftArrow.size.width/2 - 10, CGRectGetMaxY(self.view.frame) - rightArrow.size.height/2 - 10);
    upArrow.zRotation = M_PI/2;
    upArrow.name = @"upArrow";
    upArrow.zPosition = 5.0f;
    [self.scene addChild:upArrow];
    
    self.replayButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replayButton setImage:[UIImage imageNamed:@"replay.png"] forState:UIControlStateNormal];
    [self.replayButton addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
    self.replayButton.frame = CGRectMake(self.size.width / 2.0, self.size.height/2.0, 64, 64);
    [self.view addSubview:self.replayButton];
    self.replayButton.alpha = 1.0f;
    
    self.gnuLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gnuLevelButton setImage:[UIImage imageNamed:@"upArrow.png"] forState:UIControlStateNormal];
    [self.gnuLevelButton addTarget:self action:@selector(newLevel) forControlEvents:UIControlEventTouchUpInside];
    self.gnuLevelButton.frame = CGRectMake(self.size.width / 2.0, self.size.height/2.0 - 80, 64, 64);
    [self.view addSubview:self.gnuLevelButton];
    
    self.saveLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveLevelButton setImage:[UIImage imageNamed:@"saveIcon.png"] forState:UIControlStateNormal];
    [self.saveLevelButton addTarget:self action:@selector(saveLevel) forControlEvents:UIControlEventTouchUpInside];
    self.saveLevelButton.frame = CGRectMake(self.size.width / 2.0, self.size.height/2.0 - 160, 64, 64);
    [self.view addSubview:self.saveLevelButton];
    
//    self.levelTitleTextField = [[UITextField alloc] init];
//    self.levelTitleTextField.frame = CGRectMake(self.size.width / 2.0 + 20, self.size.height/2.0, 100, 20);
//   // self.levelTitleTextField.center = self.view.center;
//    self.levelTitleTextField.borderStyle = UITextBorderStyleRoundedRect;
//    self.levelTitleTextField.textColor = [UIColor blackColor];
//    self.levelTitleTextField.font = [UIFont systemFontOfSize:17.0];
//    self.levelTitleTextField.placeholder = @"Enter level name here";
//    self.levelTitleTextField.backgroundColor = [UIColor whiteColor];
//    self.levelTitleTextField.autocorrectionType = UITextAutocorrectionTypeYes;
//    self.levelTitleTextField.keyboardType = UIKeyboardTypeDefault;
//    self.levelTitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.levelTitleTextField.delegate = self.delegate;
//    self.levelTitleTextField.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin;
//    CGAffineTransform transform = CGAffineTransformMakeScale(1.0, -1.0);
//    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
//    CGAffineTransform finalTransform = CGAffineTransformConcat(transform, rotate);
//    self.levelTitleTextField.transform = finalTransform;
//    [self.view addSubview:self.levelTitleTextField];
    
    self.levelTitleTextField.alpha = 0.0f;
    self.saveLevelButton.alpha = 0.0f;
    self.replayButton.alpha = 0.0f;
    self.gnuLevelButton.alpha = 0.0f;
    
    SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
    scoot.physicsBody.allowsRotation = NO;
    [scoot childNodeWithName:@"feet"].physicsBody.allowsRotation = NO;
    self.isTouchingGround = NO;
    
    if(self.isMultiplayer){
        NSData *objectDictionaryData = [NSKeyedArchiver archivedDataWithRootObject:self.spriteDictionary];
        self.networkingEngine = [[MultiplayerNetworking alloc] init];
        self.networkingEngine.delegate = self;
        if(self.playerNumber == 0){
            [self.networkingEngine sendData:objectDictionaryData];
        }
    }

}

-(void)enemy1Attack{
    SKSpriteNode *enemy1 = (SKSpriteNode *)[self childNodeWithName:@"enemy1"];
    SKSpriteNode *enemyShot = [SKSpriteNode spriteNodeWithImageNamed:@"GEM.png"];
    enemyShot.size = CGSizeMake(25, 25);
    enemyShot.position = CGPointMake(enemy1.position.x, CGRectGetMaxY(enemy1.frame));
    enemyShot.anchorPoint = CGPointMake(.5, .5);
    enemyShot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemyShot.size];
    enemyShot.physicsBody.affectedByGravity = NO;
    enemyShot.physicsBody.dynamic = NO;
    enemyShot.zPosition = 1.0f;
    enemyShot.physicsBody.usesPreciseCollisionDetection = YES;
    enemyShot.physicsBody.categoryBitMask = projectileCategory | groundHitCategory;
    enemyShot.physicsBody.collisionBitMask = playerHitCategory | groundHitCategory;
    enemyShot.physicsBody.contactTestBitMask = playerHitCategory | groundHitCategory;
    SKAction *fireShot = [SKAction moveToY:2000 duration:5.0f];
    [self addChild:enemyShot];
    [enemyShot runAction:fireShot completion:^{
        enemyShot.hidden = YES;
        [enemyShot removeFromParent];
    }];
    NSLog(@"Enemy attacking");
    
}


-(void)checkForWin {
    if ([self childNodeWithName:@"scoot"].position.x > 1500 || [self childNodeWithName:@"scoot"].position.x < -1500 || [self childNodeWithName:@"scoot"].position.y > 1500 || [self childNodeWithName:@"scoot"].position.y < -1500) {
        [self gameOver:0];
    }
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

-(void)gameOver:(BOOL)won {
    self.gameOver = YES;
    //[self runAction:[SKAction playSoundFileNamed:@"hurt.wav" waitForCompletion:NO]];
    
    NSString *gameText;
    
    if (won) {
        gameText = @"You Won!";
    } else {
        gameText = @"You Lost!";
    }
    
    //1
    SKLabelNode *endGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt"];
    endGameLabel.text = gameText;
    endGameLabel.fontColor = [SKColor blackColor];
    endGameLabel.fontSize = 40;
    endGameLabel.xScale = -1.0f;
    endGameLabel.position = CGPointMake(self.size.width / 2.0, self.size.height / 1.7);
    endGameLabel.zRotation = M_PI/2;
    [self addChild:endGameLabel];
    
    //Add Save Levels Button
    
    
    self.replayButton.alpha = 1.0f;
    self.gnuLevelButton.alpha = 1.0f;
    self.saveLevelButton.alpha = 1.0f;
    self.levelTitleTextField.alpha = 1.0f;

    
    NSLog(@"SKView final frame: %@", NSStringFromCGRect(self.frame));
    
}

-(void)newLevel{
    
    [self.gameSceneLoop stop];
    self.replayButton.alpha = 0.0f;
    self.gnuLevelButton.alpha = 0.0f;
    self.saveLevelButton.alpha = 0.0f;
    self.levelTitleTextField.alpha = 0.0f;
    self.enemy1Timer = nil;
    if(self.levelTitleTextField.isFirstResponder){
        [self.levelTitleTextField resignFirstResponder];
    }
    
    [self.scene removeFromParent];
    [self.view presentScene:nil];
    [self.view removeFromSuperview];
    [self.delegate goBack];
}

-(void)saveLevel{
    
    if(![self.levelTitleTextField.text isEqualToString: @""]){
        NSMutableArray *savedLevelsArray = [[NSMutableArray alloc] init];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"savedLevels"]){
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedLevels"];
            savedLevelsArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        }
        [self.spriteDictionary setObject:self.levelTitleTextField.text forKey:@"levelTitle"];
        [savedLevelsArray addObject:self.spriteDictionary];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:savedLevelsArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"savedLevels"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wait!" message:@"You need to add a title to save this level!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)replay:(id)sender
{
    [self.gameSceneLoop stop];
    self.replayButton.alpha = 0.0f;
    self.gnuLevelButton.alpha = 0.0f;
    self.saveLevelButton.alpha = 0.0f;
    self.levelTitleTextField.alpha = 0.0f;
    [_enemy1Timer invalidate];
    [self.enemy1Timer invalidate];
    self.enemy1Timer = nil;
    [self removeAllChildren];
    if(self.levelTitleTextField.isFirstResponder){
        [self.levelTitleTextField resignFirstResponder];
    }
    //[self.scene removeFromParent];
    GameScene * scene = [GameScene sceneWithSize:CGSizeMake(self.size.width, self.size.height)];
    scene.objectInfoDictionary = self.objectInfoDictionary;
    [self.view presentScene:scene];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if((firstBody.categoryBitMask == groundHitCategory && secondBody.categoryBitMask == playerFeetCategory ) || (firstBody.categoryBitMask == playerFeetCategory && secondBody.categoryBitMask == groundHitCategory))
    {
        if([self childNodeWithName:@"scoot"].physicsBody.velocity.dx < 100 && [self childNodeWithName:@"scoot"].physicsBody.velocity.dx > -100){
            _isTouchingGround = YES;
            SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
            [scoot.physicsBody setVelocity:CGVectorMake(0, scoot.physicsBody.velocity.dy)];
            NSLog(@"Begin");
        }
        //Player hit the ground
    }

    
    if(firstBody.categoryBitMask == solidHitCategory || secondBody.categoryBitMask == solidHitCategory)
    {
//        CGFloat impulseX = 0.0f;
//        CGFloat impulseY = 0.0f;
//        [firstBody applyImpulse:CGVectorMake(impulseX, impulseY)];
//        [secondBody applyImpulse:CGVectorMake(impulseX, impulseY)];

    }
    
    if((firstBody.categoryBitMask == winLevelCategory && secondBody.categoryBitMask == playerHitCategory) ||
       (firstBody.categoryBitMask == playerHitCategory && secondBody.categoryBitMask == winLevelCategory )){
        [self gameOver:1];
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if((firstBody.categoryBitMask == groundHitCategory && secondBody.categoryBitMask == playerFeetCategory )|| (firstBody.categoryBitMask == playerFeetCategory && secondBody.categoryBitMask == groundHitCategory))
    {
//        SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
//        if(scoot.physicsBody.velocity.dy
            _isTouchingGround = NO;
        NSLog(@"End");
        
//        CGFloat impulseX = 0.0f;
//        CGFloat impulseY = 0.0f;
//        [[self childNodeWithName:@"scoot"].physicsBody applyImpulse:CGVectorMake(impulseX, impulseY) atPoint:[self childNodeWithName:@"scoot"].position];
        //Player hit the ground
    }
}


- (void) jump:(SKSpriteNode*)obj
{
    NSLog(@"Touching Ground: %d, VelX:%f VelY:%f", _isTouchingGround, obj.physicsBody.velocity.dx, obj.physicsBody.velocity.dx);
    //&& obj.physicsBody.velocity.dx > -30 && obj.physicsBody.velocity.dx < 30
    if (_isTouchingGround){
        _isTouchingGround = NO;
//        CGFloat impulseX = 250.0f;
//        CGFloat impulseY = 0.0f;
//        [obj.physicsBody applyImpulse:CGVectorMake(impulseX, impulseY)];
        int velY;
        if(obj.physicsBody.velocity.dy == 0){
            velY = obj.physicsBody.velocity.dy+1;
        }else{
            velY = obj.physicsBody.velocity.dy;

        }
            obj.physicsBody.velocity = CGVectorMake(-400, velY/2);
    }
}



-(void)update:(NSTimeInterval)delta{

    if(self.gameOver) return;
//    
//    SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
//    scoot.physicsBody.allowsRotation = NO;
//    [scoot childNodeWithName:@"feet"].physicsBody.allowsRotation = NO;
//    [self childNodeWithName:@"scoot"].physicsBody.angularVelocity = 0.0f;
    //    if([self isGroundPixel:self.backgroundImageView.image:[self childNodeWithName:@"scoot"].position.x :[self childNodeWithName:@"scoot"].position.y]){
    //        NSLog(@"%@", [self getRGBAsFromImage:self.backgroundImageView.image atX:[self childNodeWithName:@"scoot"].position.x andY:[self childNodeWithName:@"scoot"].position.y count:1]);
    //        NSLog(@"GROUND COLLISION");
    //    }
    //
    
    if(self.movingRight){
        SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
        scoot.physicsBody.velocity = CGVectorMake(scoot.physicsBody.velocity.dx, 150);
    }else if(self.movingLeft) {
        SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
        scoot.physicsBody.velocity = CGVectorMake(scoot.physicsBody.velocity.dx, -150);
    }
    
    [self checkForWin];
    
    //NSLog(@"XVel:%f, YVel:%f", [self childNodeWithName:@"scoot"].physicsBody.velocity.dx, [self childNodeWithName:@"scoot"].physicsBody.velocity.dx);

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
   NSLog(@"Touch X: %f, Touch Y: %f", loc.x, loc.y);
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        NSLog(@"Name:%@", n.name);
        if([n.name isEqualToString:@"rightArrow"]){
            if([[self childNodeWithName:@"scoot"] actionForKey:@"moveLeft"]){
                [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveLeft"];
            }
//            SKAction *moveRight = [SKAction moveByX:0.0f y:10000.0f duration:50.0f];
//            [[self childNodeWithName:@"scoot"] runAction:moveRight withKey:@"moveRight"];
            [self childNodeWithName:@"scoot"].yScale = 1.0f;
            self.movingLeft = NO;
            self.movingRight = YES;

        }
        else if([n.name isEqualToString:@"leftArrow"]){
//            if([[self childNodeWithName:@"scoot"] actionForKey:@"moveRight"]){
//                [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveRight"];
//            }
//            
//            SKAction *moveLeft = [SKAction moveByX:0.0f y:-10000.0f duration:50.0f];
//            [[self childNodeWithName:@"scoot"] runAction:moveLeft withKey:@"moveLeft"];
            [self childNodeWithName:@"scoot"].yScale = -1.0f;
            self.movingRight = NO;
            self.movingLeft = YES;
        } else if([n.name isEqualToString:@"upArrow"]){
            NSLog(@"Jump!");
            [self jump:(SKSpriteNode *)[self childNodeWithName:@"scoot"]];
        }
        
    }
    
//    if(self.gameOver && self.levelTitleTextField.isFirstResponder){
//        [self.levelTitleTextField resignFirstResponder];
//
//    }
    
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        SKNode *n = [self nodeAtPoint:[touch locationInNode:self]];
        if([n.name isEqualToString:@"rightArrow"]){
            [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveRight"];
            self.movingRight = NO;
            SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
            scoot.physicsBody.velocity = CGVectorMake(scoot.physicsBody.velocity.dx, 0);
        }else if([n.name isEqualToString:@"leftArrow"]){
            [[self childNodeWithName:@"scoot"] removeActionForKey:@"moveLeft"];
            self.movingLeft = NO;
            SKSpriteNode *scoot = (SKSpriteNode *)[self childNodeWithName:@"scoot"];
            scoot.physicsBody.velocity = CGVectorMake(scoot.physicsBody.velocity.dx, 0);
        }
        
    }
    
}
- (BOOL)shouldAutorotate
{
    return NO;
}



@end
