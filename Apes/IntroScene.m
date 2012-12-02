//
//  IntroScene.m
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//
//

#import "IntroScene.h"
#import "MainMenuScene.h"

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

- (id)init
{
    if (self = [super initWithColor:ccc4(255, 255, 255, 255)])
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Intro" fontName:@"Arial" fontSize:80.0f];
        title.color = ccc3(200, 0, 0);
        title.position = ccp(winSize.width / 2, winSize.height / 2);
        
        CCLabelTTF *next = [CCLabelTTF labelWithString:@"Next" fontName:@"Arial" fontSize:24.0f];
        next.color = ccc3(0, 0, 0);
        CCMenuItemLabel *nextItem = [CCMenuItemLabel itemWithLabel:next block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[[MainMenuScene alloc] init]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:nextItem, nil];
        menu.position = ccp(winSize.width - next.contentSize.width / 2 - 20, next.contentSize.height / 2 + 10);
        [self addChild:title];
        [self addChild:menu];
    }
    return self;
}

@end