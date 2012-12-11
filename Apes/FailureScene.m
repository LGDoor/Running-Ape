//
//  MainMenuScene.m
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "FailureScene.h"
#import "GameScene.h"


@implementation FailureScene
- (id)init
{
    if (self = [super init])
    {
        [self addChild:[[[FailureLayer alloc] init] autorelease]];
    }
    return self;
}
@end

@implementation FailureLayer

- (id)init
{
    if (self = [super init])
    {
//@ttgong-Add
        CCSprite *bg = [CCSprite spriteWithFile:@"final_page.png"];
        bg.anchorPoint = CGPointMake(0, 0);
        [self addChild:bg];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
        CGFloat highestScore = [userData floatForKey:HIGHEST_SCORE];
        CGFloat currentScore = [userData floatForKey:CURRENT_SCORE];
        
        NSString *highestScoreStr = [NSString stringWithFormat:@"HIGHEST: %i", (int)(highestScore)];
        NSString *currentScoreStr = [NSString stringWithFormat:@"SCORE: %i", (int)(currentScore)];
        
        CCLabelTTF *highestLabel = [CCLabelTTF labelWithString:highestScoreStr fontName:@"Arial" fontSize:14.0f];
        highestLabel.color = ccc3(0, 0, 0);
        highestLabel.anchorPoint = CGPointMake(0, 0);
        highestLabel.position = ccp(282, winSize.height - 100);
        [self addChild:highestLabel];

        CCLabelTTF *currentLabel = [CCLabelTTF labelWithString:currentScoreStr fontName:@"Arial" fontSize:30.0f];
        currentLabel.color = ccc3(0, 0, 0);
        currentLabel.anchorPoint = CGPointMake(0, 0);
        currentLabel.position = ccp(280, winSize.height - 80);
        [self addChild:currentLabel];
        
                
        CCMenuItemImage *restartItem = [CCMenuItemImage itemFromNormalImage:@"restart_button.png" selectedImage:nil target:self selector:@selector(restartGame)];
        
        
        CCMenu *menu = [CCMenu  menuWithItems:restartItem, nil];
        menu.position = ccp(winSize.width - 105, 110);
//@ttgong-End
        [self addChild:menu];
    }
    return self;
}

//@ttgong-Add
- (void)restartGame {
    GameScene *scene = [[[GameScene alloc] init] autorelease];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:0.5 scene:scene]];
}
//@ttgong-End
@end