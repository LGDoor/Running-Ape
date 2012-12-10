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
}

#define kNumBananas 5

- (id)init
{
    if (self = [super init])
    {
        _isJumping = NO;        
        
        id cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"ape.plist" textureFile:@"ape.png"];
        
        _player = [CCSprite spriteWithSpriteFrameName:@"ape1.png"];
        _player.anchorPoint = ccp(0, 1);
        _player.position = ccp(120, 60);
        CCSprite *shadow = [CCSprite spriteWithFile:@"ape_shadow.png"];
        shadow.anchorPoint = ccp(0, 1);
        shadow.position = ccp(125,27);
        [self addChild:shadow];
        
        NSMutableArray *playerFrames = [[NSMutableArray alloc] init];
        
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
            enemy = [[Police alloc] initPolice];
            enemy.anchorPoint = ccp(0,1);
            enemy.position = ccp(winSize.width, 74);
        } else if (p1 < 0.8) {    // car
            enemy = [Car car];
            enemy.anchorPoint = ccp(0,1);
            enemy.position = ccp(winSize.width, 62.5);
        } else { // plane
            enemy = [Airplane airplane];
            enemy.anchorPoint = ccp(0,1);
            enemy.position = ccp(winSize.width, 210);
        }        
        [self addChild:enemy];
        id a1 = [CCMoveBy actionWithDuration:winSize.width / POLICE_MOVE_SPEED position:ccp(-winSize.width - enemy.contentSize.width, 0)];
        id a2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
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
    //@ttgong-Add
    timeSpent = -[startDate timeIntervalSinceNow];
    [self updateUserData:timeSpent];
    //@ttgong-End
    [[CCDirector sharedDirector] replaceScene:[[FailureScene alloc] init]];
}

- (void)update:(ccTime)dt
{
    // collision dectection
    Enemy *enemyHit = nil;
    CCSprite *bananaToDelete = nil;
    
    for (CCSprite *bullet in _bullets) {
        if (CGRectIntersectsRect(bullet.boundingBox, _player.boundingBox)) {
            [self die];
        }
    }
    
    for (Enemy *enemy in _enemies) {
        CGRect actualBox = CGRectInset(_player.boundingBox, 5.0, 10.0);
        if (CGRectIntersectsRect(enemy.boundingBox, actualBox)) {
            [self die];
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
        }
    }
    
    if (enemyHit) {
        [enemyHit hit];
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
        id action1 = [CCMoveBy actionWithDuration:0.35 position:ccp(0,160)];
        id action2 = [action1 reverse];
        id action3 = [CCCallBlock actionWithBlock:^{_isJumping = NO;}];
        [_player runAction:[CCSequence actions:[CCEaseOut actionWithAction:action1 rate:2], [CCEaseIn actionWithAction:action2 rate:2], action3, nil]];
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
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCSprite *banana = [[CCSprite alloc] initWithFile:@"banana.png"];
    banana.position = ccpAdd(_player.position, ccp(_player.contentSize.width / 2, -15));
    
    [_bananas addObject:banana];
    [banana runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.3 angle:360]]];
    [banana runAction:[CCSequence actions:[CCMoveBy actionWithDuration:1.5 position:ccp(winSize.width, 0)],
                       [CCCallBlockN actionWithBlock:^(CCNode *banana) {
        [_bananas removeObject:banana];
        [self removeChild:banana cleanup:YES];
    }], nil]];
    [self addChild:banana];
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
        _objLayer = objLayer;
        _jumpButton = [CCMenuItemImage itemFromNormalImage:@"jump_button.png" selectedImage:@"jump_button.png" target:_objLayer selector:@selector(onJumpTapped)];
        _jumpButton.position = ccp(40, 50);
        _shootButton = [CCMenuItemImage itemFromNormalImage:@"shot_button.png" selectedImage:@"shot_button.png" target:_objLayer selector:@selector(onShootTapped)];
        _shootButton.position = ccp(440, 50);
        _pauseButton = [CCMenuItemImage itemFromNormalImage:@"pause_button.png" selectedImage:@"pause_button.png" target:self selector:@selector(onPauseButton)];
        _pauseButton.position = ccp(35, 290);
        CCMenu *menu = [CCMenu menuWithItems:_jumpButton, _shootButton, _pauseButton, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume) name:@"resume" object:nil];
    }
    return self;
}

- (void)onPauseButton
{
    PauseLayer *pauseLayer = [[PauseLayer alloc] init];
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
        CCMenuItemImage *resumeButton = [CCMenuItemImage itemFromNormalImage:@"start_button.png" selectedImage:@"start_button.png" target:self selector:@selector(onResumeButton)];
        resumeButton.position = ccp(0, 0);
        CCMenu *menu = [CCMenu menuWithItems:resumeButton, nil];
        [self addChild:menu];
    }
    return self;
}

- (void)onResumeButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resume" object:self];
    [self removeFromParentAndCleanup:YES];
}

@end