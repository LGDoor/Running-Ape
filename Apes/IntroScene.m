//
//  IntroScene.m
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//
//

#import "IntroScene.h"
#import "MainMenuScene.h"
#import "GameScene.h"

@implementation IntroScene

- (id)init
{
    if (self = [super init])
    {
        [self addChild:[[[StoryLayer alloc] init] autorelease]];
    }
    return self;
}

@end

@implementation StoryLayer
{
    int _tapCount;
    CCSprite *_storyPage;
}

//@ttgong-Add
- (id)init
{
    if (self = [super init])
    {
        _tapCount = 0;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _storyPage = [[CCSprite alloc] init];
        
        // page 1
        CCSprite *page1 = [CCSprite spriteWithFile:@"page1.png"];
        page1.anchorPoint = ccp(0, 0);
        page1.position = CGPointZero;
        [_storyPage addChild:page1];
        
        // page 2
        CCSprite *page2 = [CCSprite spriteWithFile:@"page2.png"];
        page2.anchorPoint = ccp(0, 0);
        page2.position = ccp(winSize.width, 0);
        [_storyPage addChild:page2];
        
        [self addChild:_storyPage];
        self.isTouchEnabled = YES;
    }
    return self;
}

- (void)dealloc
{
    [_storyPage release];
    [super dealloc];
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    _tapCount++;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    if (_tapCount < 2) {
        CCMoveBy *moveLeft = [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:0.5 position:ccp(-winSize.width, 0)] rate:2.0];
        [_storyPage runAction:moveLeft];
    } else {
        MainMenuScene *scene = [[[MainMenuScene alloc] init] autorelease];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInR transitionWithDuration:0.5 scene:scene]];
    }
}
//@ttgong-End
@end