//
//  IntroScene.h
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//
//

#import "cocos2d.h"

@interface IntroScene : CCScene

@end
//@ttgong-Add
@interface StoryLayer : CCLayerColor <CCTargetedTouchDelegate>
{
    BOOL movedLeft;
    BOOL shouldMove;
    
    CGSize winSize;
}
//@ttgong-End
@end