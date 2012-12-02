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
        [self addChild:[[MenuLayer alloc] init]];
    }
    return self;
}
@end

@implementation MenuLayer

- (id)init
{
    if (self = [super initWithColor:ccc4(255, 255, 255, 255)])
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Title" fontName:@"Arial" fontSize:30.0f];
        title.color = ccc3(200, 0, 0);
        title.position = ccp(winSize.width / 2, winSize.height - 60);
        
        CCLabelTTF *next = [CCLabelTTF labelWithString:@"Start!" fontName:@"Arial" fontSize:40.0f];
        next.color = ccc3(0, 0, 0);
        CCMenuItemLabel *nextItem = [CCMenuItemLabel itemWithLabel:next block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[[GameScene alloc] init]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:nextItem, nil];
        menu.position = ccp(winSize.width / 2, winSize.height / 2 + 10);
        [self addChild:title];
        [self addChild:menu];
    }
    return self;
}
@end