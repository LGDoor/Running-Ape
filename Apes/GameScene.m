//
//  HelloWorldLayer.m
//  Apes
//
//  Created by 余 向洋 on 12-11-23.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


#import "GameScene.h"
#import "FailureScene.h"
#import "Enemy.h"

@implementation GameScene
-(id) init
{
    if (self = [super init])
    {
        _bgLayer = [[BackgroundLayer alloc] init];
        _objLayer = [[ObjectsLayer alloc] init];
        _hudLayer = [[HudLayer alloc] initWithObjLayer:_objLayer];
        [self addChild:_bgLayer z:-1];
        [self addChild:_objLayer];
        [self addChild:_hudLayer];
    }
    return self;
}

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"game_bgm.mp3" loop:YES];
}

- (void)onExit
{
    [super onExit];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}
- (void)onExitTransitionDidStart
{
    [super onExitTransitionDidStart];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void)dealloc
{
    [_bgLayer release];
    [_objLayer release];
    [_hudLayer release];
    [super dealloc];
}
@end

@implementation BackgroundLayer

// on "init" you need to initialize your instance
-(id) init
{
	if (self=[super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];

		CCSprite *cityb1 = [CCSprite spriteWithFile:@"city_b.png"];
        cityb1.anchorPoint = ccp(0,0);
        cityb1.position = ccp(0,57);
        CCSprite *cityb2 = [CCSprite spriteWithFile:@"city_b.png"];
        cityb2.anchorPoint = ccp(0,0);
        cityb2.position = ccp(cityb1.contentSize.width - 1, 57);
        _cityb = [[CCSprite alloc] init];
        [_cityb addChild:cityb1];
        [_cityb addChild:cityb2];
        id a1 = [CCMoveBy actionWithDuration:winSize.width / CITY_A_SCROLL_SPEED position:ccp(-cityb1.contentSize.width, 0)];
        id a2 = [CCPlace actionWithPosition:ccp(0, 0)];
        [_cityb runAction:[CCRepeatForever actionWithAction:[CCSequence actions:a1, a2, nil]]];
        
        CCSprite *citya1 = [CCSprite spriteWithFile:@"city_a.png"];
        citya1.anchorPoint = ccp(0,0);
        citya1.position = ccp(0,57);
        CCSprite *citya2 = [CCSprite spriteWithFile:@"city_a.png"];
        citya2.anchorPoint = ccp(0,0);
        citya2.position = ccp(citya1.contentSize.width - 1, 57);
        _citya = [[CCSprite alloc] init];
        [_citya addChild:citya1];
        [_citya addChild:citya2];
        a1 = [CCMoveBy actionWithDuration:winSize.width / CITY_B_SCROLL_SPEED position:ccp(-citya1.contentSize.width, 0)];
        a2 = [CCPlace actionWithPosition:ccp(0, 0)];
        [_citya runAction:[CCRepeatForever actionWithAction:[CCSequence actions:a1, a2, nil]]];
        
        CCSprite *ground1 = [CCSprite spriteWithFile:@"ground.png"];
        ground1.anchorPoint = ccp(0,0);
        ground1.position = ccp(0,0);
        CCSprite *ground2 = [CCSprite spriteWithFile:@"ground.png"];
        ground2.anchorPoint = ccp(0,0);
//@ttgong-Modify
        ground2.position = ccp(ground1.contentSize.width - 1, 0);
//@ttgong-End
        _ground = [[CCSprite alloc] init];
        [_ground addChild:ground1];
        [_ground addChild:ground2];
        a1 = [CCMoveBy actionWithDuration:winSize.width / GROUND_SCROLL_SPEED position:ccp(-ground1.contentSize.width, 0)];
        a2 = [CCPlace actionWithPosition:ccp(0, 0)];
        [_ground runAction:[CCRepeatForever actionWithAction:[CCSequence actions:a1, a2, nil]]];
        [self addChild:_cityb];
        [self addChild:_citya];
        [self addChild:_ground];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:@"pause" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:@"resume" object:nil];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_citya release];
    [_cityb release];
    [_ground release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)onPause
{
    [self pauseSchedulerAndActions];
    for (CCSprite *sprite in self.children) {
        [sprite pauseSchedulerAndActions];
    }
}

- (void)onResume
{
    [self resumeSchedulerAndActions];
    for (CCSprite *sprite in self.children) {
        [sprite resumeSchedulerAndActions];
    }
}
@end

@implementation ObjectsLayer
{
    BOOL _isJumping;
//    NSMutableArray *_bananasPool;
    NSMutableArray *_bananas;
    NSMutableArray *_enemies;
    NSMutableArray *_bullets;
    int nBananas;
}
@synthesize currentScore = _currentScore;

- (id)init
{
    if (self = [super init])
    {
        _isJumping = NO;
        nBananas = 0;
        _currentScore = 0;
        
        id cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"ape.plist" textureFile:@"ape.png"];
        
        _player = [[CCSprite spriteWithSpriteFrameName:@"ape1.png"] retain];
        _player.anchorPoint = ccp(0, 1);
        _player.position = ccp(120, 60);
        CCSprite *shadow = [CCSprite spriteWithFile:@"ape_shadow.png"];
        shadow.anchorPoint = ccp(0, 1);
        shadow.position = ccp(125,27);
        [self addChild:shadow];
        
        NSMutableArray *playerFrames = [[[NSMutableArray alloc] init] autorelease];
        
        [playerFrames addObject:[cache spriteFrameByName:@"ape1.png"]];
        [playerFrames addObject:[cache spriteFrameByName:@"ape2.png"]];
        CCAnimation *playerAnimation = [CCAnimation animationWithFrames:playerFrames delay:0.15f];
        [_player runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:playerAnimation restoreOriginalFrame:NO]]];
        [self addChild:_player];
        
        [cache addSpriteFramesWithFile:@"police.plist" textureFile:@"police.png"];
        
//        _bananasPool = [[NSMutableArray alloc] init];
//        for (int i = 0; i < kNumBananas; i++) {
//            CCSprite *banana = [CCSprite spriteWithFile:@"banana.png"];
//            banana.visible = NO;
//            [_bananasPool addObject:banana];
//            [self addChild:banana];
//        }
        
        _enemies = [[NSMutableArray alloc] init];
        _bananas = [[NSMutableArray alloc] init];
        _bullets = [[NSMutableArray alloc] init];
        
        [self schedule:@selector(addEnemy) interval:0.5f];
        [self schedule:@selector(enemyShoot) interval:1.5f];
        [self scheduleUpdate];
//@ttgong-Add
        startDate = [[NSDate date] retain];
//@ttgong-End
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPause) name:@"pause" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:@"resume" object:nil];
    }
    return self;
}
//@ttgong-Add
- (void)dealloc
{
    [startDate release], startDate = nil; 
    [_player release];
    [_bananas release];
    [_enemies release];
    [_bullets release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
//@ttgong-End
#define ARC4RANDOM_MAX      0x100000000
- (void)addEnemy
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    double p0 = ((double)arc4random() / ARC4RANDOM_MAX);
    if (p0 < 0.4) {
        double p1 = ((double)arc4random() / ARC4RANDOM_MAX);
        CCSprite *enemy = nil;
        if (p1 < 0.4) {     // police
            enemy = [[[Police alloc] initPolice] autorelease];
            enemy.anchorPoint = ccp(0,1);
            enemy.position = ccp(winSize.width, 74);
        } else if (p1 < 0.8) {    // car
            enemy = [[[Car alloc] initCar] autorelease];
            enemy.anchorPoint = ccp(0,1);
            enemy.position = ccp(winSize.width, 62.5);
        } else { // plane
            enemy = [[[Airplane alloc] initAirplane] autorelease];
            enemy.anchorPoint = ccp(0,1);
            enemy.position = ccp(winSize.width, 210);
        }        
        [self addChild:enemy];
        id a1 = [CCMoveBy actionWithDuration:winSize.width / POLICE_MOVE_SPEED position:ccp(-winSize.width - enemy.contentSize.width, 0)];
        id a2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [node stopAllActions];
            [node removeFromParentAndCleanup:YES];
            [_enemies removeObject:node];
        }];
        [enemy runAction:[CCSequence actions:a1, a2, nil]];
        [_enemies addObject:enemy];
    }
}

- (void)enemyShoot
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    // random bullet
    for (Enemy *enemy in _enemies) {
        if ([enemy isKindOfClass:[Police class]]) {
            double p0 = ((double)arc4random() / ARC4RANDOM_MAX);
            if (p0 < 0.4) {
                [enemy fireBlink];
                CCSprite *bullet = [CCSprite spriteWithFile:@"bullet.png"];
                [_bullets addObject:bullet];
                bullet.position = ccp(enemy.position.x, 46);
                id a1 = [CCMoveBy actionWithDuration:size.width / BULLET_MOVE_SPEED position:ccp(-size.width, 0)];
                id a2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    [node stopAllActions];
                    [node removeFromParentAndCleanup:YES];
                    [_bullets removeObject:node];
                }];
                [bullet runAction:[CCSequence actions:a1, a2, nil]];
                [self addChild:bullet z:-1];
            }
        }
    }
}

//@ttgong-Add
- (void)updateUserData:(CGFloat)score {
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setFloat:score forKey:CURRENT_SCORE];
    
    
    CGFloat highestScore = [userData floatForKey:HIGHEST_SCORE];
    if(highestScore<score) [userData setFloat:score forKey:HIGHEST_SCORE];
    [userData synchronize];
}
//@ttgong-End

- (void)die
{
#ifndef GOD_MODE
    //@ttgong-Add
    [self updateUserData:_currentScore];
    //@ttgong-End
    [[CCDirector sharedDirector] replaceScene:[[[FailureScene alloc] init] autorelease]];
#endif
}

- (void)update:(ccTime)dt
{
    _currentScore += dt * 10;
    
    // collision dectection
    Enemy *enemyHit = nil;
    
    for (CCSprite *bullet in _bullets) {
        if (CGRectIntersectsRect(bullet.boundingBox, _player.boundingBox)) {
            [self die];
            return;
        }
    }
    
    for (Enemy *enemy in _enemies) {
        CCSprite *bananaToDelete = nil;
        CGRect actualBox = CGRectInset(_player.boundingBox, 5.0, 10.0);
        if (CGRectIntersectsRect(enemy.boundingBox, actualBox)) {
            [self die];
            return;
        }

        for (CCSprite *banana in _bananas) {
            if (CGRectIntersectsRect(enemy.boundingBox, banana.boundingBox)) {
                enemyHit = enemy;
                bananaToDelete = banana;
                break;
            }
        }
        
        if (bananaToDelete) {
            [bananaToDelete stopAllActions];
            [_bananas removeObject:bananaToDelete];
            [self removeChild:bananaToDelete cleanup:YES];
            nBananas--;
        }
    }
    
    if (enemyHit) {
        [enemyHit hit];
        [[SimpleAudioEngine sharedEngine] playEffect:@"enemy_hit.wav"];
        if (enemyHit.hp == 0) {
            [enemyHit stopAllActions];
            [_enemies removeObject:enemyHit];
            [self removeChild:enemyHit cleanup:YES];
        }
    }
}

- (void)onJumpTapped
{
    if (!_isJumping) {
        _isJumping = YES;
        id action1 = [CCMoveBy actionWithDuration:0.4 position:ccp(0,160)];
        id action2 = [CCDelayTime actionWithDuration:0.08];
        id action3 = [action1 reverse];
        id action4 = [CCCallBlock actionWithBlock:^{_isJumping = NO;}];
        [_player runAction:[CCSequence actions:[CCEaseOut actionWithAction:action1 rate:2], action2, [CCEaseIn actionWithAction:action3 rate:2], action4, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"jump.wav"];
    }
}

- (void)onShootTapped
{
//    if (_bananasPool.count > 0) {
//        CGSize winSize = [CCDirector sharedDirector].winSize;
//        CCSprite *banana = _bananasPool[0];
//        [_bananasPool removeObjectAtIndex:0];
//        
//        [_flyingBananas addObject:banana];
//        banana.position = ccpAdd(_player.position, ccp(_player.contentSize.width/2, 0));
//        banana.visible = YES;
//        [banana stopAllActions];
//        [banana runAction:[CCSequence actions:
//                           [CCMoveBy actionWithDuration:0.5 position:ccp(winSize.width, 0)],
//                           [CCCallBlockN actionWithBlock:^(CCNode *banana) {
//            banana.visible = NO;
//            [_bananasPool addObject:banana];
//        }], nil]];
//    }
//
    if (nBananas < kMaxBananas) {
        nBananas++;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *banana = [CCSprite spriteWithFile:@"banana.png"];
        double flyingDist = winSize.width - _player.position.x;
        banana.position = ccpAdd(_player.position, ccp(_player.contentSize.width / 2, -15));
        
        [_bananas addObject:banana];
        [banana runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.3 angle:360]]];
        [banana runAction:[CCSequence actions:[CCMoveBy actionWithDuration:flyingDist / BANANA_MOVE_SPEED position:ccp(flyingDist, 0)], [CCCallBlockN actionWithBlock:^(CCNode *banana) {
            [banana stopAllActions];
            [_bananas removeObject:banana];
            [self removeChild:banana cleanup:YES];
            nBananas--;
        }], nil]];
        [self addChild:banana z:-1];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"banana.wav"];
    }
}

- (void)onPause
{
    [self pauseSchedulerAndActions];
    for (CCSprite *sprite in self.children) {
        [sprite pauseSchedulerAndActions];
    }
}

- (void)onResume
{
    [self resumeSchedulerAndActions];
    for (CCSprite *sprite in self.children) {
        [sprite resumeSchedulerAndActions];
    }
}

@end

@implementation HudLayer

-(id)initWithObjLayer:(ObjectsLayer*)objLayer
{
    if (self = [super init])
    {
        _objLayer = [objLayer retain];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        _jumpButton = [[CCMenuItemImage itemFromNormalImage:@"jump_button.png" selectedImage:@"jump_button.png" target:_objLayer selector:@selector(onJumpTapped)] retain];
        _jumpButton.position = ccp(40, 40);
        _shootButton = [[CCMenuItemImage itemFromNormalImage:@"shot_button.png" selectedImage:@"shot_button.png" target:_objLayer selector:@selector(onShootTapped)] retain];
        _shootButton.position = ccp(winSize.width - 40, 40);
        _pauseButton = [[CCMenuItemImage itemFromNormalImage:@"pause_button.png" selectedImage:@"pause_button.png" target:self selector:@selector(onPauseButton)] retain];
        _pauseButton.position = ccp(35, 290);
        
        CCMenu *menu = [CCMenu menuWithItems:_jumpButton, _shootButton, _pauseButton, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
        _scoreLabel = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"numbers.png" itemWidth:15 itemHeight:19 startCharMap:'0'] retain];
        _scoreLabel.anchorPoint = ccp(1, 0.5);
        _scoreLabel.position = ccp(430, 280);
        [self addChild:_scoreLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:@"resume" object:nil];
    }
    return self;
}

- (void)draw
{
    _scoreLabel.string = [NSString stringWithFormat:@"%i", (int)(_objLayer.currentScore)];
    [super draw];
}

- (void)dealloc
{
    [_objLayer release];
    [_jumpButton release];
    [_shootButton release];
    [_pauseButton release];
    [_scoreLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)onPauseButton
{
    PauseLayer *pauseLayer = [[[PauseLayer alloc] init] autorelease];
    [self.parent addChild:pauseLayer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pause" object:self];
    _jumpButton.visible = NO;
    _shootButton.visible = NO;
    _pauseButton.visible = NO;
}

- (void)onResume
{
    _jumpButton.visible = YES;
    _shootButton.visible = YES;
    _pauseButton.visible = YES;
}

@end

@implementation PauseLayer

- (id)init
{
    if (self = [super initWithColor:ccc4(0, 0, 0, 128)]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCMenuItemImage *resumeButton = [CCMenuItemImage itemFromNormalImage:@"start_button.png" selectedImage:@"start_button.png" target:self selector:@selector(onResumeButton)];
        resumeButton.position = ccp(winSize.width / 2 - 60, winSize.height / 2);
        
        CCMenuItemImage *restartButton = [CCMenuItemImage itemFromNormalImage:@"restart_button.png" selectedImage:@"restart_button.png" target:self selector:@selector(onRestartButton)];
        restartButton.position = ccp(winSize.width / 2 + 60, winSize.height / 2);
        
        CCMenuItemImage *muteImage = [CCMenuItemImage itemFromNormalImage:@"mute_button.png" selectedImage:@"mute_button.png"];
        CCMenuItemImage *unmuteImage = [CCMenuItemImage itemFromNormalImage:@"unmute_button.png" selectedImage:@"unmute_button.png"];
        CCMenuItemToggle *muteButton = [CCMenuItemToggle itemWithBlock:^(id sender) {
            SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
            CCMenuItemToggle *button = (CCMenuItemToggle *)sender;
            if (button.selectedItem == muteImage)
            {
                engine.mute = YES;
            } else {
                engine.mute = NO;
            }
        } items:unmuteImage, muteImage, nil];
        muteButton.position = ccp(40, 40);
        
        CCMenu *menu = [CCMenu menuWithItems:resumeButton, restartButton, muteButton, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
    }
    return self;
}

- (void)onResumeButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resume" object:self];
    [self removeFromParentAndCleanup:YES];
}

- (void)onRestartButton
{
    GameScene *scene = [[[GameScene alloc] init] autorelease];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:0.5 scene:scene]];
}
@end