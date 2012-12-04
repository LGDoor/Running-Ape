//
//  HelloWorldLayer.h
//  Apes
//
//  Created by 余 向洋 on 12-11-23.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

//@ttgong-Add
#define HIGHEST_SCORE @"highestScore"
#define CURRENT_SCORE @"currentScore"
#define BACKGROUND_SCROLL_DURATION 3.0
//@ttgong-End

@interface BackgroundLayer : CCLayer
{
    CCSprite *_city;
    CCSprite *_ground;
}
@end

@interface ObjectsLayer : CCLayer
{
    CCSprite *_player;
//@ttgong-Add    
    NSDate *startDate;
    CGFloat timeSpent;
//@ttgong-End
}

@end

@interface HudLayer : CCLayer
{
    ObjectsLayer *_objLayer;
    CCMenuItem *_jumpButton;
    CCMenuItem *_shootButton;
}

-(id)initWithObjLayer:(ObjectsLayer*)objLayer;
@end

@interface GameScene : CCScene
{
    BackgroundLayer *_bgLayer;
    ObjectsLayer *_objLayer;
    HudLayer *_hudLayer;
}
@end

