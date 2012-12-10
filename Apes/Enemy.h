//
//  Police.h
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//
//

#import "cocos2d.h"

@interface Enemy : CCSprite
@property (nonatomic, assign) int hp;

- (void)hit;
@end

@interface Police : Enemy
{
    CCSprite *_fire;
    CCSprite *_shadow;
}
- (id)initPolice;
- (void)fireBlink;
@property (nonatomic, strong, readonly) CCSpriteBatchNode *batchNode;
@end

@interface Car : Enemy
+ (Car*)car;
@end

@interface Airplane : Enemy
+ (Airplane*)airplane;
@end