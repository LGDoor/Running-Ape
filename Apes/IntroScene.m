//
//  IntroScene.m
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//
//

#import "IntroScene.h"
#import "MainMenuScene.h"
//@ttgong-Add
#import "GameScene.h"
//@ttgong-End

@implementation IntroScene

- (id)init
{
    if (self = [super init])
    {
        [self addChild:[[StoryLayer alloc] init]];
    }
    return self;
}

@end

@implementation StoryLayer
//@ttgong-Add
- (id)init
{
    if (self = [super initWithColor:ccc4(255, 255, 255, 255)])
    {
        winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Intro" fontName:@"Arial" fontSize:80.0f];
        title.color = ccc3(200, 0, 0);
        title.position = ccp(winSize.width / 2, winSize.height / 2);
        
        CCLabelTTF *next = [CCLabelTTF labelWithString:@"Enter" fontName:@"Arial" fontSize:36.0f];
        next.color = ccc3(220, 0, 0);
        CCMenuItemLabel *nextItem = [CCMenuItemLabel itemWithLabel:next block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[[GameScene alloc] init]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:nextItem, nil];
        menu.position = ccp(winSize.width - next.contentSize.width / 2 - 20, next.contentSize.height / 2 + 10);
        
        // background layer
        shouldMove = YES;
        CCLayerColor *page = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255) width:winSize.width height:winSize.height];
        page.anchorPoint = CGPointMake(0, 0.5);
        page.tag = 999;
        [self addChild:page];
        
        // page 1
        CCSprite *page1 = [CCSprite spriteWithFile:@"page1.jpg" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
        page1.anchorPoint = CGPointMake(0, 0);
        [page addChild:page1];
        
        // page 2
        CCSprite *page2 = [CCSprite spriteWithFile:@"page2.jpg" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
        page2.anchorPoint = CGPointMake(-1, 0);
        [page addChild:page2];

        // page 3
        CCSprite *page3 = [CCSprite spriteWithFile:@"page3.jpg" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
        page3.anchorPoint = CGPointMake(-1, 1);
        [page addChild:page3];
        [page3 addChild:menu];
    }
    return self;
}


- (void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:TRUE];
    [super onEnter];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // page animation
    if(!shouldMove) return;
    CCLayerColor *page = (CCLayerColor *)[self getChildByTag:999];
    if ( !movedLeft ) {
        shouldMove = NO;
        CCMoveBy *moveLeft = [CCMoveBy actionWithDuration:0.5 position:CGPointMake(-winSize.width, 0)];
        id enableTouch = [CCCallFunc actionWithTarget:self selector:@selector(enableTouch)];
        [page runAction:[CCSequence actionOne:moveLeft two:enableTouch]];
        movedLeft = YES;
    } else {
        shouldMove = NO;
        CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.5 position:CGPointMake(0, winSize.height)];
        [page runAction:moveUp];
    }
}

- (void)enableTouch {
    shouldMove = YES;
}
//@ttgong-End
@end