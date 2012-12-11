//
//  MainMenuScene.m
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameScene.h"


@implementation MainMenuScene
- (id)init
{
    if (self = [super init])
    {
        [self addChild:[[[MenuLayer alloc] init] autorelease]];
    }
    return self;
}
@end

@implementation MenuLayer

- (id)init
{
    if (self = [super init])
    {        
        CCSprite *bg = [CCSprite spriteWithFile:@"main_menu_bg.png"];
        bg.anchorPoint = CGPointZero;
        [self addChild:bg z:-1];
        
        CCMenuItemImage *startBtn = [CCMenuItemImage itemFromNormalImage:@"start_button.png" selectedImage:@"start_button.png"  block:^(id sender){
            GameScene *scene = [[[GameScene alloc] init] autorelease];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:0.5 scene:scene]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:startBtn, nil];
        menu.position = ccp(360, 100);
        [self addChild:menu];
    }
    return self;
}
@end